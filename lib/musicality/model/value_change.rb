module Musicality

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
  include Hashmake::HashMakeable

  attr_reader :value, :transition
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :value => arg_spec(:reqd => true),
    :transition => arg_spec(:reqd => false, :type => Transition, :default => ->(){ Musicality::immediate() })
  }

  # New instance of ValueChange.
  # @param [Hash] args Hashed arguments for initialization.
  def initialize args
    hash_make ValueChange::ARG_SPECS, args
  end
  
  # Compare the equality of another ValueChange object.
  def == other
    return (@value == other.value) &&
    (@transition == other.transition)
  end
  
  # Produce an identical ValueChange object
  def clone
    return ValueChange.new(:value => @value, :transition => @transition)
  end

  # Set the event value. Can be any object.
  def value= value
    validate_arg ValueChange::ARG_SPECS[:value], value
    @value = value
  end

  # Set the transition.
  def transition= transition
    validate_arg ValueChange::ARG_SPECS[:transition], transition
    @transition = transition
  end
end

# Creates a ValueChange object
# @param [Object] value
# @param [Transition] transition
def self.value_change(value, transition = immediate())
  return ValueChange.new(:value => value, :transition => transition)
end

# Creates a ValueChange object using an immediate transition.
# @param [Object] value
def self.immediate_change(value)
  return ValueChange.new(:value => value, :transition => immediate())
end

# Creates a ValueChange object using a linear transition.
# @param [Object] value
# @param [Transition] transition_duration Length of the transition
def self.linear_change(value, transition_duration = 0.0)
  return ValueChange.new(:value => value, :transition => linear(transition_duration))
end

# Creates a ValueChange object using a sigmoid transition.
# @param [Object] value
# @param [Transition] transition_duration Length of the transition
def self.sigmoid_change(value, transition_duration = 0.0)
  return ValueChange.new(:value => value, :transition => sigmoid(transition_duration))
end

end

