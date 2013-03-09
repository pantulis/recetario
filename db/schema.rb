# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20091009232043) do

  create_table "ingredients", force: true do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingredients_recipes", id: false, force: true do |t|
    t.integer "ingredient_id"
    t.integer "recipe_id"
  end

  create_table "meals", force: true do |t|
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "published_at"
    t.integer  "recipe_id"
    t.integer  "plan_id"
    t.integer  "user_id"
    t.datetime "updated_at"
  end

  create_table "plans", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
