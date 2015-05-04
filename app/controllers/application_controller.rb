module ActionController
  class StrictParameters < Parameters
    # Parameters uses global configuration stored in a class variable...
    # What if I need an engine at some point?
    # What if I have controllers that want to treat this differently?
    # ...so doing it this wonky ass way, instead
    def self.action_on_unpermitted_parameters
      :raise
    end
  end
end

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
    @params ||= ActionController::StrictParameters.new params
  end
end
