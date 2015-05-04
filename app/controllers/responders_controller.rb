class RespondersController < ApplicationController

  def index
    if params[:show] == 'capacity'
      render json: { capacity: Responder.capacity_counts }
    else
      render json: { responders: Responder.all }
    end
  end

  def show
    responder = Responder.find_by name: params[:name]
    return not_found! unless responder
    render json: { responder: responder }
  end

  def create
    responder_params   = params.require(:responder).permit(:type, :name, :capacity)
    unpermitted_params = unpermitted_params responder_params
    responder          = Responder.new responder_params

    if unpermitted_params.any?
      render status: :unprocessable_entity,
             json: { message: "found unpermitted parameter: #{unpermitted_params.join ', '}" }
    elsif responder.save
      render status: :created, json: { responder: responder }
    else
      render status: :unprocessable_entity, json: { message: responder.errors }
    end
  end

  def update
    responder_params   = params.require(:responder).permit(:on_duty)
    unpermitted_params = unpermitted_params(responder_params)
    responder = Responder.find_by name: params[:name]

    if unpermitted_params.any?
      render status: :unprocessable_entity,
             json: { message: "found unpermitted parameter: #{unpermitted_params.join ', '}" }
    elsif responder.update_attributes responder_params
      render json: { responder: responder }
    else
      raise 'unhandled'
    end
  end

  private

  def unpermitted_params(responder_params)
    params[:responder].keys - responder_params.keys
  end
end
