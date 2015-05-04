# Setup so that this file can be run directly, without loading Rails
# If there winds up being more classes than just this one, then move it out to a common helper
require 'minitest/autorun' unless defined? Minitest
libdir = File.expand_path('../lib', __dir__)
$:.unshift libdir unless $LOAD_PATH.include? libdir


require 'minitest/spec'
require 'dispatch'

class DispatchTest < Minitest::Spec
  # there should probably be a heuristic at some point, e.g. severity=100, responder1-100 have capacity of 1, responder 101 has capacity of 101.
  # the described algorithm would choose responders 1 through 100, but if the next two emergencies have severity of 1, the second one will not have enough responders to be addressed.
  # but if we instead dispatch the 101 responder, then we could handle any number of emergencies until their cumulative severity exceeds 100.
  def dispatches!(emergency:, responders:, dispatched:)
    [*emergency, *responders].each { |hash| hash[:type] ||= 'sometype' }
    emergency  = Dispatch::Emergency.new emergency
    responders = responders.map { |responder| Dispatch::Responder.new responder }
    actuals    = Dispatch emergency, responders
    dispatched.each do |expected|
      responder = find_dispatched actuals, expected
      assert responder, "Expected #{expected.inspect} to be in #{actuals.inspect}"
    end
  end

  def find_dispatched(actuals, expected)
    actuals.find do |actual|
      expected.all? do |attribute, value|
        actual.__send__(attribute) == value
      end
    end
  end

  it 'dispatches responders for the given type' do
    dispatches! emergency:  [{type: 'a', severity: 1}],
                responders: [{type: 'a', capacity: 1}, {type: 'b', capacity: 1}],
                dispatched: [{type: 'a'}]

    dispatches! emergency:  [{type: 'a', severity: 1}],
                responders: [{type: 'b', capacity: 1}, {type: 'a', capacity: 1}],
                dispatched: [{type: 'a'}]
  end

  it 'dispatches responders for each type that the emergency requires' do
    dispatches! emergency:  [{type: 'a', severity: 1}, {type: 'b', severity: 1}],
                responders: [{type: 'a', capacity: 1}, {type: 'b', capacity: 1}],
                dispatched: [{type: 'a', capacity: 1}, {type: 'b', capacity: 1}]
  end

  it 'dispatches responders until the emergency has a full response' do
    dispatches! emergency:  [{severity: 2}],
                responders: [{capacity: 1}, {capacity: 1}, {capacity: 1}],
                dispatched: [{capacity: 1}, {capacity: 1}]
  end

  it 'chooses responders whose capcity matches the severity before responders with surplus capacity' do
    dispatches! emergency:  [{severity: 2}],
                responders: [{capacity: 2}, {capacity: 3}],
                dispatched: [{capacity: 2}]

    dispatches! emergency:  [{severity: 2}],
                responders: [{capacity: 3}, {capacity: 2}],
                dispatched: [{capacity: 2}]
  end

  it 'chooses responders whose capacity matches the severity before responders with a deficit of capacity' do
    dispatches! emergency:  [{severity: 2}],
                responders: [{capacity: 2}, {capacity: 1}],
                dispatched: [{capacity: 2}]

    dispatches! emergency:  [{severity: 2}],
                responders: [{capacity: 1}, {capacity: 2}],
                dispatched: [{capacity: 2}]
  end

  it 'given multiple ways to get to a capacity, it opts for fewer responders, so that future emergencies will have options' do
    dispatches! emergency:  [{severity: 3}],
                responders: [{capacity: 1}, {capacity: 2}, {capacity: 3}, {capacity: 4}],
                dispatched: [{capacity: 3}]

    dispatches! emergency:  [{severity: 3}],
                responders: [{capacity: 4}, {capacity: 3}, {capacity: 2}, {capacity: 1}],
                dispatched: [{capacity: 3}]

    dispatches! emergency:  [{severity: 3}],
                responders: [{capacity: 1}, {capacity: 1}, {capacity: 1}, {capacity: 2}, {capacity: 4}],
                dispatched: [{capacity: 1}, {capacity: 2}]
  end
end
