class ExceptionalParameters < ActionController::Parameters
  # Parameters uses global configuration stored in a class variable...
  # What if I need an engine at some point?
  # What if I have controllers that want to treat this differently?
  # ...so doing it this wonky ass way, instead
  def self.action_on_unpermitted_parameters
    :raise
  end
end
