class EmergenciesController < ApplicationController

  def index
    render json: { emergencies: Emergency.all }
  end

  def show
    render json: { emergency: Emergency.find(params[:code]) }
  end

  def create
    emergency_params   = params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
    unpermitted_params = unpermitted_params(emergency_params)
    emergency = Emergency.new(emergency_params)

    if unpermitted_params.any?
      render status: :unprocessable_entity,
             json: { message: "found unpermitted parameter: #{unpermitted_params.join ', '}" }
    elsif emergency.save
      render status: :created, json: { emergency: emergency }
    else
      render status: :unprocessable_entity, json: { message: emergency.errors }
    end
  end

  def update
    emergency_params   = params.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity)
    unpermitted_params = unpermitted_params(emergency_params)
    emergency = Emergency.find params[:code]

    if unpermitted_params.any?
      render status: :unprocessable_entity,
             json: { message: "found unpermitted parameter: #{unpermitted_params.join ', '}" }
    elsif emergency.update_attributes emergency_params
      render json: { emergency: emergency }
    else
      raise 'unhandled'
    end
  end

  private

  def unpermitted_params(emergency_params)
    params[:emergency].keys - emergency_params.keys
  end
end
