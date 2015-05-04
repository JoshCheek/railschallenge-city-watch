require 'minitest/spec'

class DispatchRespondersTest < Minitest::Spec
  # there should probably be a heuristic at some point, e.g. severity=100, responder1-100 have capacity of 1, responder 101 has capacity of 101.
  # the described algorithm would choose responders 1 through 100, but if the next two emergencies have severity of 1, the second one will not have enough responders to be addressed.
  # but if we instead dispatch the 101 responder, then we could handle any number of emergencies until their cumulative severity exceeds 100.

  it 'dispatches responders for the given type'
  it 'dispatches responders until the emergency has a full response'
  it 'chooses responders whose capcity matches the severity before responders with surplus capacity'
  it 'chooses responders whose capacity matches the severity before responders with a deficit of capacity'
  it 'given multiple ways to get to a capacity, it opts for fewer responders, so that future emergencies will have options'
  it 'dispatches responders for each type that the emergency requires'
  it 'is a full response if the allocated capacity meets or exceeds the severity'
end
