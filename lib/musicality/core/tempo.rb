module Musicality

# Abstraction of a musical tempo.
#
# @author James Tunnell
# 
# @!attribute [rw] beats_per_minute
#   @return [Numeric] Determine the tempo in beats per minute.
#
# @!attribute [rw] beat_duration
#   @return [Rational] The length of each beat (in note length)
#
class Tempo < Event

  attr_reader :beat_duration, :beats_per_minute
  
  # A new instance of Tempo.
  # @param [Hash] args Hashed arguments. Required keys are :beats_per_minute, 
  #                    :beat_duration, and :offset. Optional key is :duration.
  def initialize args = {}
    raise ArgumentError, ":beats_per_minute key not present in args Hash" if !args.has_key?(:beats_per_minute)
    raise ArgumentError, ":beat_duration key not present in args Hash" if !args.has_key?(:beat_duration)
    raise ArgumentError, ":offset key not present in args Hash" if !args.has_key?(:offset)
    
    self.beats_per_minute = args[:beats_per_minute]
    self.beat_duration = args[:beat_duration]
  
    opts = {
      :duration => 0.0
    }.merge args
    
    super opts[:offset], opts[:duration]
  end
  
  # Set the beats per minute
  # @param [Numeric] beats_per_minute The tempo in beats per minute (bpm)
  # @raise [RangeError] if tempo is less than or equal to zero.
  def beats_per_minute= beats_per_minute
    raise RangeError, "tempo is less than or equal to zero" if beats_per_minute <= 0
  	@beats_per_minute = beats_per_minute
  end

  # Set the duration of a beat.
  # @param [Rational] duration The length of each beat (in note length).
  # @raise [ArgumentError] if duration is not a Rational and does not respond to :to_r
  # @raise [RangeError] if duration is less than zero.
  def beat_duration= duration
    if !duration.is_a?(Rational)
  	  raise ArgumentError, "duration is not a Rational and does not respond to :to_r" if !duration.respond_to?(:to_r)
  	  duration = duration.to_r
  	end

  	raise RangeError, "duration is less than 0." if duration < 0
  	@beat_duration = duration
  end
end

end
