# coding: utf-8
# A plan is a set of meal within given dates
# It generates the list of ingredients to buy and
# performs de export to the To-Do system of choice

class PlansController < ApplicationController
  def index
    @collection = Plan.all.includes(:meals)
  end

  def new
    @resource = Plan.new
  end

  def create
    @resource = Plan.new_from_calendar(params)
    flash[:notice] = 'Calendario creado'

    redirect_to action: :index
  end

  def edit
    @resource = Plan.find(params[:id])
  end

  def update
    @resource = Plan.find(params[:id])
    @resource.update_from_calendar(params)
    flash[:notice] = 'Calendario guardado'
    redirect_to action: :edit
  end

  def destroy
    @resource = Plan.find(params[:id])
    @resource.destroy
    flash[:warning] = 'Calendario borrado'
    redirect_to action: :index
  end

  def toodledo
    @resource = Plan.find(params[:id])
    @text = @resource.export_toodledo
  end

  def wunderlist
    @resource = Plan.find(params[:id])
    @text = @resource.export_wunderlist
  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:plan).permit(:name, :description, recipes: [], dates: [])]
  end
end
