class PlansController < ApplicationController

  def index
    @collection = Plan.all
  end
  
  def new
    @resource = Plan.new
  end

  def create
    @resource = Plan.new_from_calendar(params)
    flash[:notice] = 'Calendario creado'

    redirect_to :action => "index"
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
  
  def export
    @resource = Plan.find(params[:id])
    @text = @resource.export_toodledo
  end
  
  private
  
  def resource_params
      return [] if request.get?
      [ params.require(:plan).permit(:name, :description, :recipes => [], :dates => []) ]
  end
end
