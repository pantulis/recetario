# encoding: UTF-8
# schema.rb

ActiveRecord::Schema.define(version: 20_091_009_232_043) do
  create_table 'ingredients', force: true do |t|
    t.string 'name'
    t.integer 'position'
    t.integer 'user_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'ingredients_recipes', id: false, force: true do |t|
    t.integer 'ingredient_id'
    t.integer 'recipe_id'
  end

  create_table 'meals', force: true do |t|
    t.datetime 'date'
    t.datetime 'created_at'
    t.datetime 'published_at'
    t.integer 'recipe_id'
    t.integer 'plan_id'
    t.integer 'user_id'
    t.datetime 'updated_at'
  end

  create_table 'plans', force: true do |t|
    t.string 'name'
    t.integer 'user_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'recipes', force: true do |t|
    t.string 'name'
    t.text 'description'
    t.integer 'user_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end
end
