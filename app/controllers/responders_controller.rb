class RespondersController < ApplicationController

  def index
    if params[:show] == 'capacity'
      render json: { capacity: Responder.capacity_counts }
    else
      render json: { responders: Responder.all }
    end
  end

  def show
    render json: { responder: Responder.find(params[:name]) }
  end

  def create
    responder = Responder.new params!.require(:responder).permit(:type, :name, :capacity)

    if responder.save
      render status: :created, json: { responder: responder }
    else
      render status: :unprocessable_entity, json: { message: responder.errors }
    end
  end

  def update
    responder_params = params!.require(:responder).permit(:on_duty)
    responder        = Responder.find params[:name]
    responder.update_attributes responder_params
    render json: { responder: responder }
  end
end
