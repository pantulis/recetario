# coding: utf-8

class IngredientsController < InheritedResources::Base
  def create
    super do |format|
      format.html { redirect_to ingredients_url }
    end
  end

  def update
    super do |format|
      format.html { redirect_to edit_ingredient_url(resource) }
    end
  end

  private

  def collection
    end_of_association_chain.includes(:recipes)
  end

  def resource_params
    return [] if request.get?
    [params.require(:ingredient).permit(:name)]
  end
end
