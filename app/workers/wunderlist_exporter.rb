# -*- coding: utf-8 -*-
# This class exports a given recipe and ingredient lisk to Wunderlist

class WunderlistExporter
  @queue = :exporters_queue

  def self.perform(plan_id)
    plan = Plan.find(plan_id)
    tasks_to_export = []
    ingredients = []
    folder_id = ''

    plan.meals.each do |meal|
      ingredients << meal.recipe.ingredients.all
    end

    ingredients.flatten.group_by(&:id).each do |_k, v|
      my_recipes = plan.recipes.all.select do |recipe|
        recipe.ingredients.include? v.first
      end

      title = if v.length == 1
                "#{v.first.name}"
              else
                "#{v.first.name} (*#{my_recipes.length})"
              end

      note = my_recipes.map(&:name).join(',')
      tasks_to_export << { title: title,
                           folder: folder_id,
                           note: note }
    end

    wl = Wunderlist::API.new(
      access_token: ENV['WUNDERLIST_ACCESS_TOKEN'],
      client_id: ENV['WUNDERLIST_CLIENT_ID'])

    tasks_to_export.each do |t|
      Rails.logger.debug ("[Wunderlist Exporter] => : #{t[:title]} (#{t[:note]})")
      task = wl.new_task(ENV['WUNDERLIST_TASKS_FOLDER'], title: t[:title])
      task.save
      note = task.note
      note.content = t[:note]
      note.save
    end
  end
end
