class Meal < ActiveRecord::Base
  belongs_to :plan
  belongs_to :recipe
  belongs_to :user

end
