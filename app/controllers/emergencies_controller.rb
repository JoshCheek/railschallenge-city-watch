class EmergenciesController < ApplicationController
  class Emergency < ActiveRecord::Base
    establish_connection adapter: 'sqlite3', database: ':memory:'

    connection.create_table table_name, id: false do |t|
      t.string  :code
      t.integer :fire_severity,    null: false
      t.integer :police_severity,  null: false
      t.integer :medical_severity, null: false
    end

    self.primary_key = :code

    validates :fire_severity, :police_severity, :medical_severity,
              presence:     true,
              numericality: { greater_than_or_equal_to: 0 }

    validates :code, uniqueness: true, presence: true
  end

  def index
    render json: { emergencies: Emergency.all }
  end

  def show
    emergency = Emergency.find_by code: params[:code]
    return render status: :not_found, json: {} unless emergency
    render json: { emergency: emergency }
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
    emergency = Emergency.find_by code: params[:code]

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
