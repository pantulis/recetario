class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :meals, :dependent => :destroy
  has_many :recipes, :through => :meals


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

  def export_toodledo
    logger.debug("[Toodledo] Iniciando session")

    if Settings.toodledo.export 
      session = Toodledo::Session.new(Settings.toodledo.userid, Settings.toodledo.password)
      session.connect()
    end

    logger.debug("[Toodledo] Creando carpeta recetas")
  
    recetas_folder_id = session.add_folder("recetas del #{Time.now.strftime('%d-%m')}").to_i if Settings.toodledo.export

    ingredients = []
    self.meals.each do |meal|
      ingredients << meal.recipe.ingredients
    end

    throttle = 0
    ingredients.flatten.sort_by(&:position).group_by(&:id).each {|k,v|
      sleep 1 if (throttle % 5 == 0)
      recipes = self.recipes.select{|recipe| recipe.ingredients.include? v.first}
      
      title = if v.length == 1
        "#{v.first.name}" 
      else
        "#{v.first.name} (*#{recipes.length})"
      end

      note = recipes.map(&:name).join(',')
      logger.debug("[Toodledo] #{title} (#{note})")        
      
      session.add_task(title , 
        :folder => recetas_folder_id,
        :note => note)   if Settings.toodledo.export
        
      throttle += 1
    }
    logger.debug("[Toodledo] Cerrando sesion")
    session.disconnect() if Settings.toodledo.export
  end

end


