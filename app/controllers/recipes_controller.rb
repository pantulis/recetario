# coding: utf-8
# Recipes are boring sets of ingredients with a
# description

class RecipesController < InheritedResources::Base
  def create
    super do |format|
      format.html { redirect_to recipes_url }
    end
  end

  def update
    super do |format|
      format.html { redirect_to edit_recipe_url(resource) }
    end
  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:recipe).permit(:name, :description, ingredient_ids: [])]
  end
end
