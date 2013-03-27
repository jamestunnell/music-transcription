module Musicality

# A musical event, with an offset, duration, and value.
#
# @author James Tunnell
#
# @!attribute [rw] offset
#   @return [Rational] The offset of the event. be in the range MIN_OFFSET..MAX_OFFSET
#
# @!attribute [rw] duration
#   @return [Rational] The duration of the event. Must be in the range MIN_OFFSET..MAX_OFFSET
#
# @!attribute [rw] value
#   @return [Rational] The value of the event.
#
class Event
  # the minimum event offset allowed
  MIN_OFFSET = -(2 **(0.size * 8 - 2))
  # the maximum event offset allowed
  MAX_OFFSET = (2 **(0.size * 8 - 2) - 2)

  attr_reader :offset, :duration, :value

  # New instance of Event.
  # @param [Numeric] offset The event offset.
  # @param [Numeric] value The event value.
  # @param [Numeric] duration The event duration. Zero by default. 
  def initialize offset, value, duration = 0.0
    self.offset = offset
    self.value = value
    self.duration = duration
  end
  
  # Compare the equality of another Event object.
  def == other
    return (@offset == other.offset) &&
    (@duration == other.duration) &&
    (@value == other.value)
  end

  # Set the event offset.
  # @param [Numeric] offset The offset of the event.
  # @raise [ArgumentError] if offset is not a Numeric.
  # @raise [RangeError] if offset is less than MIN_OFFSET or greater than MAX_OFFSET.
  def offset= offset
    raise ArgumentError, "offset #{offset} is not a Numeric" if !offset.is_a?(Numeric)
    raise RangeError, "offset  #{offset} is outside the range #{MIN_OFFSET}..#{MAX_OFFSET}." if !(MIN_OFFSET..MAX_OFFSET).include?(offset)
  	
    @offset = offset
  end

  # Set the event duration.
  # @param [Numeric] duration The duration of the event.
  # @raise [ArgumentError] if duration is not a Numeric.
  # @raise [RangeError] if duration is negative.
  def duration= duration
    raise ArgumentError, "duration is not a Numeric" if !duration.is_a?(Numeric)
    raise RangeError, "duration is negative" if duration < 0.0
  	
    @duration = duration
  end

  # Set the event value. Can be any object.
  def value= value
    @value = value
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

  # Take an array of events and return a hash of the events by duration.
  # @param [Array] events An array of events.
  def self.hash_events_by_duration events
    hash = {}
    
    events.each do |event|
      hash[event.duration] = event
    end
  
    return hash
  end
  
end

end

