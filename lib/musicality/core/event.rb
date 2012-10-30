module Musicality

# A musical event, with an offset and duration in note length.
#
# @author James Tunnell
#
# @!attribute [rw] offset
#   @return [Rational] The offset of the event in note lengths.
#
# @!attribute [rw] duration
#   @return [Rational] The duration of the event in note lengths.
#
class Event

  # the minimum event offset allowed
  MIN_OFFSET = -(2 **(0.size * 8 - 2))
  # the maximum event offset allowed
  MAX_OFFSET = (2 **(0.size * 8 - 2) - 2)

  attr_reader :offset, :duration

  # New instance of Event.
  # @param [Numeric] offset The offset of the event.
  # @param [Numeric] duration The duration of the event.
  def initialize offset, duration
    self.offset = offset
    self.duration = duration
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
  # @raise [RangeError] if duration is less than MIN_OFFSET or greater than MAX_OFFSET.
  def duration= duration
    raise ArgumentError, "duration is not a Numeric" if !duration.is_a?(Numeric)
  	raise RangeError, "duration is outside the range #{MIN_OFFSET}..#{MAX_OFFSET}." if !(MIN_OFFSET..MAX_OFFSET).include?(duration)
  	
  	@duration = duration
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

