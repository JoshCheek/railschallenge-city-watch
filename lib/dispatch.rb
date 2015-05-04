def Dispatch(emergency, all_responders)
  Dispatch.new(emergency, all_responders).call
end

class Dispatch
  def initialize(emergency, all_responders)
    @emergency, @all_responders = emergency, all_responders
  end

  def call
    @dispatched ||= @emergency.each_type.with_object [] do |(type, severity), dispatched|
      for_type    = responders_for type
      by_capacity = by_relative_capacity for_type, severity
      if by_capacity[:exact].any?
        dispatched << by_capacity[:exact].first
      end
    end
  end

  private

  def responders_for(type)
    @all_responders.select { |r| r.type? type }
  end

  def by_relative_capacity(responders, severity)
    mapping = { -1 => :deficit, 0 => :exact, 1 => :surplus }
    responders.each_with_object deficit: [], exact: [], surplus: [] do |responder, mapped|
      key = mapping[severity <=> responder.capacity]
      mapped[key] << responder
    end
  end
end

class Dispatch::Emergency
  attr_accessor :attrs_by_type
  def initialize(attrs_by_type)
    self.attrs_by_type = attrs_by_type
  end

  def each_type
    return to_enum :each_type unless block_given?
    attrs_by_type.each do |attrs|
      yield attrs[:type], attrs[:severity]
    end
  end
end

class Dispatch::Responder
  attr_accessor :type, :capacity
  def initialize(type:, capacity:)
    self.type, self.capacity = type, capacity
  end

  def type?(type)
    self.type == type
  end
end
