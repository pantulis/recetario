class WunderlistExporter
  @queue = :exporters_queue

  def self.perform(plan_id)
    wl = Wunderlist::API.new({:access_token => ENV['WUNDERLIST_ACCESS_TOKEN'], 
                              :client_id =>  ENV['WUNDERLIST_CLIENT_ID'] })

    plan = Plan.find(plan_id)
    tasks_to_export = []                          
    ingredients = []
    folder_id = ""
    
    plan.meals.each do |meal|
      ingredients << meal.recipe.ingredients.all
    end
    
    ingredients.flatten.group_by(&:id).each {|k,v|
      my_recipes = plan.recipes.all.select{|recipe| recipe.ingredients.include? v.first}
      
      title = (v.length == 1 ? "#{v.first.name}" : "#{v.first.name} (*#{my_recipes.length})")
      
      note = my_recipes.map(&:name).join(',')
      tasks_to_export << {:title => title, :folder => folder_id, :note => note} 
    }
    
    
    tasks_to_export.each do |t|
      task = wl.new_task(ENV['WUNDERLIST_TASKS_FOLDER'], {:title => t[:title]})
      task.save
      note = task.note
      
      note.content = t[:note]
      note.save
    end
    
  end
end
  
