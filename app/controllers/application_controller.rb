class ApplicationController < ActionController::Base
  def not_found!
    render status: :not_found, json: { message: 'page not found' }
  end

  rescue_from(ActiveRecord::RecordNotFound) { not_found! }
end
