require 'dispatch'

class EmergenciesController < ApplicationController
  def index
    emergencies = Emergency.all.to_a

    render json: {
      emergencies:    emergencies,
      full_responses: [emergencies.count(&:full_response?), emergencies.count]
    }
  end

  def show
    render json: { emergency: Emergency.find(params[:code]) }
  end

  def create
    emergency_params = params!.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
    emergency        = Emergency.new(emergency_params) { |e| e.responders = Dispatch e, Responder.available }

    if emergency.save
      render status: :created, json: { emergency: emergency }
    else
      render status: :unprocessable_entity, json: { message: emergency.errors }
    end
  end

  def update
    emergency_params = params!.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
    if emergency_params[:resolved_at]
      emergency_params[:responders] = []
    end
    emergency = Emergency.find params[:code]
    emergency.update_attributes emergency_params
    render json: { emergency: emergency }
  end
end
