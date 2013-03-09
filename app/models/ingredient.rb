class Ingredient < ActiveRecord::Base
  
  #acts_as_list :scope => :user
  acts_as_list 
#  default_scope -> { order(nam 'name ASC')}
  
  has_and_belongs_to_many :recipes
end
