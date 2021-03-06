def Dispatch(emergency, all_responders)
  Dispatch.new(emergency, all_responders).call
end

class Dispatch
  def initialize(emergency, all_responders)
    @emergency, @all_responders = emergency, all_responders
  end

  def call
    @dispatched ||= @emergency.each_type.reduce [] do |dispatched, (type, severity)|
      dispatched.concat find_match(severity, responders_for(type))
    end
  end

  private

  def responders_for(type)
    @all_responders.select { |r| r.type? type }
  end

  def find_match(severity, responders)
    return [] if !severity || severity.zero?

    exact = find_exact_match(severity, responders)
    return exact if exact.any?

    over = responders.select { |r| severity < r.capacity }.min_by(&:capacity)
    return [over] if over

    responders
  end

  def find_exact_match(severity, responders)
    0.upto responders.length do |num_responders|
      responders.combination num_responders do |to_respond|
        return to_respond if to_respond.map(&:capacity).inject(0, :+) == severity
      end
    end
    []
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
