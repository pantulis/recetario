# -*- coding: utf-8 -*-

class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :meals, :dependent => :destroy
  has_many :recipes, :through => :meals
  has_many :ingredients, :through => :recipes
  

  def self.meals_for_today
    Meal.where("date < ? and date > ?", Date.today, Date.today-1)
  end

  def self.new_from_calendar(params)
    recipes = params[:recipes]
    dates = params[:dates]
    
    plan = Plan.new

    recipes.each_with_index do |recipe,idx| 
      r = Recipe.find(recipe)
      m = Meal.new
      m.recipe = r
      m.date = DateTime.parse(dates[idx])
      m.save
      
      plan.meals << m
    end
    plan.save
    
  end
  
  def update_from_calendar(params)
    recipes = params[:recipes]
    dates = params[:dates]
    
    meals.destroy_all
    
    recipes.each_with_index do |recipe,idx| 
      r = Recipe.find(recipe)
      m = Meal.new
      m.recipe = r
      m.date = DateTime.parse(dates[idx])
      m.save
      
      meals << m
    end
    save
  end
  
  def events_for_calendar
    meals.map do |meal|
       { title: meal.recipe.name, start: meal.date, recipe_id: meal.recipe.id }
    end.to_json.html_safe
  end
  
  def start_date
    self.meals.sort_by(&:date).first.date
  end
  
  def end_date
    self.meals.sort_by(&:date).last.date
  end
  
  def dump_calendar
    ret = []
    meals.sort_by(&:date).group_by(&:date).each do |date, meals|
      ret << "\n- #{date.strftime("%d-%m")}" 
      meals.each do |meal|
        ret << "\t" << meal.recipe.name << "\n"
      end
    end
    ret.flatten.join("")
  end

  def dump_ingredients
    ingredients = []
    self.meals.each do |meal|
      ingredients << meal.recipe.ingredients
    end
    ret = []
    ingredients.flatten.sort_by(&:position).group_by(&:id).each{ |k,v| 
      ret << v.first.name  
      if v.length > 1 
        ret << "(*" << v.length << ")"
      end
      ret << "\n"
    }
    ret.flatten.join("")
    
    # ingredients.to_yaml
  end
  
  def export_omnifocus
    res = ""
    
    ingredients = []
    self.meals.each do |meal|
      ingredients << meal.recipe.ingredients
    end

    ingredients.flatten.sort_by(&:position).group_by(&:id).each {|k,v|
      recipes = self.recipes.select{|recipe| recipe.ingredients.include? v.first}
      
      title = if v.length == 1
        "#{v.first.name}" 
      else
        "#{v.first.name} (*#{recipes.length})"
      end

      note = recipes.map(&:name).join(',')

      res << "--" + title + "\n"
      res << note + "\n"
    }
    res
  end

  def export_wunderlist

      wl = Wunderlist::API.new({:access_token => ENV['wunderlist_access_token'], 
                                :client_id =>  ENV['wunderlist_client_id'] })

      tasks_to_export = []                          
      ingredients = []
      folder_id = ""
      
      meals.each do |meal|
        ingredients << meal.recipe.ingredients.all
     end
      
      ingredients.flatten.group_by(&:id).each {|k,v|
        my_recipes = self.recipes.all.select{|recipe| recipe.ingredients.include? v.first}
        
        title = (v.length == 1 ? "#{v.first.name}" : "#{v.first.name} (*#{my_recipes.length})")
        
        note = my_recipes.map(&:name).join(',')
        tasks_to_export << {:title => title, :folder => folder_id, :note => note} 
      }
      
      
      tasks_to_export.each do |t|
        task = wl.new_task(ENV['wunderlist_tasks_folder'], {:title => t[:title]})
        task.save
        note = task.note
        
        note.content = t[:note]
        note.save
      end
  end

  def export_toodledo
    token       = Toodledo::get_session_token()
    key         = Toodledo::set_key(token)
    folder_id   = nil
    folder_name = I18n.l(start_date.to_date,:format => :short) + " al " +  I18n.l(end_date.to_date , :format => :short)
    ingredients = []
    tasks_to_export = []

    folder_id = Toodledo::add_folder(key, folder_name)
    
    meals.each do |meal|
      ingredients << meal.recipe.ingredients.all
    end

    ingredients.flatten.group_by(&:id).each {|k,v|
      my_recipes = self.recipes.all.select{|recipe| recipe.ingredients.include? v.first}

      title = (v.length == 1 ? "#{v.first.name}" : "#{v.first.name} (*#{my_recipes.length})")

      note = my_recipes.map(&:name).join(',')
      tasks_to_export << {:title => title, :folder => folder_id, :note => note} 
    }

    Toodledo::add_tasks(key, tasks_to_export)
    tasks_to_export
  end
  
  
end


