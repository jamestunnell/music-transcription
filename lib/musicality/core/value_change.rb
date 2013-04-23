module Musicality

# A value change event, with an offset, duration, value, and transition type.
#
# @author James Tunnell
#
# @!attribute [rw] offset
#   @return [Numeric] The offset of the event. be in the range MIN_OFFSET..MAX_OFFSET
#
# @!attribute [rw] duration
#   @return [Numeric] The duration of the event. Must be in the range MIN_OFFSET..MAX_OFFSET
#
# @!attribute [rw] value
#   @return [Numeric] The value of the event.
#
class ValueChange
  include Hashmake::HashMakeable

  # the minimum event offset allowed
  MIN_OFFSET = -(2 **(0.size * 8 - 2))
  # the maximum event offset allowed
  MAX_OFFSET = (2 **(0.size * 8 - 2) - 2)

  attr_reader :offset, :value, :transition
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :offset => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ (MIN_OFFSET..MAX_OFFSET).include?(a) }),
    :value => arg_spec(:reqd => true),
    :transition => arg_spec(:reqd => false, :type => Transition, :default => ->(){ immediate() })
  }

  # New instance of ValueChange.
  # @param [Hash] args Hashed arguments for initialization.
  def initialize args
    hash_make ValueChange::ARG_SPECS, args
  end
  
  # Compare the equality of another ValueChange object.
  def == other
    return (@offset == other.offset) &&
    (@value == other.value) &&
    (@transition == other.transition)
  end
  
  # Produce an identical ValueChange object
  def clone
    return ValueChange.new(:offset => @offset, :value => @value, :transition => @transition)
  end

  # Set the event offset.
  # @param [Numeric] offset The offset of the event.
  # @raise [ArgumentError] if offset is not a Numeric.
  # @raise [RangeError] if offset is less than MIN_OFFSET or greater than MAX_OFFSET.
  def offset= offset
    validate_arg ValueChange::ARG_SPECS[:offset], offset
    @offset = offset
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

  # Take an array of events and return a hash of the events by offset.
  # @param [Array] events An array of events.
  def self.hash_events_by_offset events
    hash = {}
    
    events.each do |event|
      hash[event.offset] = event
    end
  
    return hash
  end

end

# Creates a ValueChange object
# @param [Numeric] offset
# @param [Object] value
# @param [Transition] transition
def value_change(offset, value, transition = immediate())
  return ValueChange.new(:offset => offset, :value => value, :transition => transition)
end

end

