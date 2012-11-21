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
  include HashMake
  attr_reader :beat_duration, :beats_per_minute

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [
    spec_arg(:beats_per_minute, Numeric, ->(a){ a > 0.0}),
    spec_arg(:beat_duration, Numeric, ->(a){ a > 0.0}),
    spec_arg(:offset, Numeric, ->(a){ a.between?(Event::MIN_OFFSET, Event::MAX_OFFSET) } )
  ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg(:duration, Numeric, ->(a){ a >= 0.0}, 0.0) ]

  # A new instance of Tempo.
  # @param [Hash] args Hashed arguments. Required keys are :beats_per_minute, 
  #                    :beat_duration, and :offset. Optional key is :duration.
  def initialize args = {}
    process_args args
  end
  
  # Set the beats per minute
  # @param [Numeric] beats_per_minute The tempo in beats per minute (bpm)
  # @raise [RangeError] if tempo is less than or equal to zero.
  def beats_per_minute= beats_per_minute
    raise RangeError, "tempo is less than or equal to zero" if beats_per_minute <= 0
  	@beats_per_minute = beats_per_minute
  end

  # Set the duration of a beat.
  # @param [Numeric] duration The length of each beat (in note length).
  # @raise [ArgumentError] if duration is not a Numeric
  # @raise [RangeError] if duration is less than zero.
  def beat_duration= duration
    raise ArgumentError, "duration is not a Numeric" if !duration.is_a?(Numeric)
  	raise RangeError, "duration is less than 0." if duration < 0
  	@beat_duration = duration
  end

  # Get the tempo in notes-per-second (rather than beats per minute).
  #
  # @return [Numeric] The tempo in notes-per-second.
  def notes_per_second
    (@beats_per_minute / 60.0) * @beat_duration
  end

  # Set the tempo using notes-per-second (rather than beats per minute).
  #
  # @param [Numeric] nps Tempo in notes-per-second. Used to calculate beats-per-minute.
  # @param [Numeric] beat_duration Specify the beat duration to use in calculating
  #                                beats-per-minute. By default the current beat duration
  #                                is used.
  def notes_per_second= nps, beat_duration = @beat_duration
    @beat_duration = beat_duration
    @beats_per_minute = (nps / @beat_duration) * 60.0
  end
end

end
