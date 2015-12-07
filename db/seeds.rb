# -*- coding: utf-8 -*-
# Seeds.rb
#

require 'csv'

Ingredient.destroy_all

CSV.foreach('./db/ingredients.csv', headers: true) do |row|
  Ingredient.create!(
    id: row['id'],
    name: row['name'],
    position: row['position'],
    user_id: row['user_id'],
    created_at: row['created_at'],
    updated_at: row['updated_at'])
end

Recipe.destroy_all

CSV.foreach('./db/recipes.csv', headers: true) do |row|
  Recipe.create!(
    id: row['id'],
    name: row['name'],
    description: row['description'],
    user_id: row['user_id'],
    created_at: row['created_at'],
    updated_at: row['updated_at']
  )
end

CSV.foreach('./db/ingredients_recipes.csv', headers: true) do |row|
  Rails.logger.info(row.inspect)

  recipe_id = row['recipe_id'].to_i
  ingredient_id = row['ingredient_id'].to_i

  Rails.logger.info "recipe_id => #{recipe_id}"
  Rails.logger.info "ingredient_id => #{ingredient_id}"

  recipe = Recipe.find(recipe_id)
  ingredient = Ingredient.find(ingredient_id)

  Rails.logger.info "#{recipe.name} => #{ingredient.name}"

  recipe.ingredients << ingredient
  ingredient.recipes << recipe
end
