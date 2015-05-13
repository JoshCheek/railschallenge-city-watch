class RespondersController < ApplicationController
  def index
    if 'capacity' == params[:show]
      render json: { capacity: Capacities.counts }
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
    responder = Responder.find params[:name]
    responder.update_attributes(params!.require(:responder).permit(:on_duty))
    render json: { responder: responder }
  end
end
