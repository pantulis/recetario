# coding: utf-8

class Recipe < ActiveRecord::Base

  belongs_to :user
  default_scope { order('name ASC') }
  has_and_belongs_to_many :ingredients

  attr_accessor :ingredients_tokens

  def ingredients_tokens=(ids)
    self.ingredients = Ingredient.find(ids.split(','))
  end

end
