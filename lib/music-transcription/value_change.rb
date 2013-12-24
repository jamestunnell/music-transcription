module Music
module Transcription

# A value change event, with a value and transition.
#
# @author James Tunnell
#
# @!attribute [rw] duration
#   @return [Numeric] The duration of the event. Must be in the range MIN_OFFSET..MAX_OFFSET
#
# @!attribute [rw] value
#   @return [Numeric] The value of the event.
#
class ValueChange
  attr_accessor :value, :transition

  # New instance of ValueChange.
  # @param [Hash] args Hashed arguments for initialization.
  def initialize value, transition = Transition::Immediate.new
    @value = value
    @transition = transition
  end
  
  # Compare the equality of another ValueChange object.
  def == other
    return (@value == other.value) &&
    (@transition == other.transition)
  end
  
  # Produce an identical ValueChange object
  def clone
    return ValueChange.new(@value, @transition.clone)
  end
end

module_function

# Creates a ValueChange object using an immediate transition.
# @param [Object] value
def immediate_change(value)
  return ValueChange.new(value, Transition::Immediate.new)
end

# Creates a ValueChange object using a linear transition.
# @param [Object] value
# @param [Transition] transition_duration Length of the transition
def linear_change(value, transition_duration = 0.0)
  return ValueChange.new(value, Transition::Linear.new(transition_duration))
end

# Creates a ValueChange object using a sigmoid transition.
# @param [Object] value
# @param [Transition] transition_duration Length of the transition
def sigmoid_change(value, transition_duration = 0.0, abruptness = 0.5)
  return ValueChange.new(value, Transition::Sigmoid.new(transition_duration, abruptness))
end

end
end
