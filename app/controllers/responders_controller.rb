class RespondersController < ApplicationController
  class Responder < ActiveRecord::Base
    establish_connection adapter: 'sqlite3', database: ':memory:'

    connection.create_table table_name do |t|
      t.string  :type
      t.string  :name
      t.integer :capacity
      t.string  :emergency_code
      t.boolean :on_duty, default: false
    end

    self.inheritance_column = nil
    validates :capacity, presence: true, inclusion: { in: 1..5 }
    validates :type,     presence: true
    validates :name,     presence: true, uniqueness: true

    def as_json(*)
      { emergency_code: emergency_code,
        type:           type,
        name:           name,
        capacity:       capacity,
        on_duty:        on_duty,
      }
    end
  end

  def index
    render json: { emergencies: Responder.all }
  end

  def show
    responder = Responder.find_by code: params[:code]
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
    responder_params   = params.require(:responder).permit(:type, :name, :capacity)
    unpermitted_params = unpermitted_params(responder_params)
    responder = Emergency.find_by code: params[:code]

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
