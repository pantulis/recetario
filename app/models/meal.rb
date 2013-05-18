class Meal < ActiveRecord::Base
  belongs_to :plan
  belongs_to :recipe
  belongs_to :user
  has_many :ingredients, :through => :recipe
end
