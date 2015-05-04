Dispatch = Module.new

class Dispatch::Emergency
  attr_accessor :types
  def initialize(types)
    self.types = types
  end
end

class Dispatch::Responder
  attr_accessor :type, :capacity
  def initialize(type:, capacity:)
    self.type, self.capacity = type, capacity
  end
end

def Dispatch(emergency, responders)
  []
end
