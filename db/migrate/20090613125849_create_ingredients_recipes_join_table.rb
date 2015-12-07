# -*- coding: utf-8 -*-
# create ingredients recipes join table
class CreateIngredientsRecipesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :ingredients_recipes, id: false do |t|
      t.references :ingredient, :recipe
    end
  end

  def self.down
    drop_table :ingredients_recipes
  end
end
