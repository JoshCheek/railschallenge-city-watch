require 'exceptional_parameters'

class ApplicationController < ActionController::Base
  def not_found!
    render status: :not_found, json: { message: 'page not found' }
  end

  rescue_from ActiveRecord::RecordNotFound do
    not_found!
  end

  rescue_from ActionController::UnpermittedParameters do |exception|
    render status: :unprocessable_entity, json: { message: exception.message }
  end

  private

  def params!
    @params ||= ExceptionalParameters.new params
  end
end
