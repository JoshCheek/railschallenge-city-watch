require 'dispatch'

class EmergenciesController < ApplicationController
  def index
    emergencies = Emergency.includes(:responders, :archived_responders).to_a

    render json: {
      emergencies:    emergencies,
      full_responses: [emergencies.count(&:full_response?), emergencies.length]
    }
  end

  def show
    render json: { emergency: Emergency.find(params[:code]) }
  end

  def create
    eparams = params!.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)

    emergency = Emergency.new eparams do |e|
      e.archived_responders = e.responders = Dispatch e, Responder.available
    end

    if emergency.save
      render status: :created, json: { emergency: emergency }
    else
      render status: :unprocessable_entity, json: { message: emergency.errors }
    end
  end

  def update
    eparams = params!.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
    eparams[:responders] = [] if eparams[:resolved_at]
    emergency = Emergency.find params[:code]
    emergency.update_attributes eparams
    render json: { emergency: emergency }
  end
end
