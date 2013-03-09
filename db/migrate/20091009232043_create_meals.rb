class CreateMeals < ActiveRecord::Migration
  def self.up
    create_table :meals do |t|
      t.datetime :date
      t.datetime :created_at
      t.datetime :published_at
      t.integer :recipe_id
      t.integer :plan_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :meals
  end
end
