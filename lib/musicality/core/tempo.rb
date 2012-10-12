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
# @!attribute [rw] transition
#   @return [Transition] Determine the length and shape of transition
#
class Tempo

  attr_reader :beat_duration, :beats_per_minute, :transition
  
  # A new instance of Tempo.
  # @param [Numeric] beats_per_minute tempo in beats per minute (bpm)
  # @param [Rational] beat_duration The length of each beat (in note length)
  # @param [Rational] transition_duration The time to transition to the desired 
  #                                       tempo. Zero by default.
  # @param [Symbol] transition_shape The shape of transition to employ (e.g. 
  #                                  linear, sigmoid). See VALID_TRANSITIONS for
  #                                  the permitted types). Linear by default.
  def initialize beats_per_minute, beat_duration, transition_duration = 0.to_r, transition_shape = Transition::SHAPE_LINEAR
    self.beats_per_minute = beats_per_minute
    self.beat_duration = beat_duration
    self.transition = Transition.new transition_duration, transition_shape
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

  # Set the temp transition.
  # @param [Transition] transition The transition to this temp.
  # @raise [ArgumentError] if transition is not a Transition.
  def transition= transition
    raise ArgumentError, "transition is not a Transition" if !transition.is_a?(Transition)
  	@transition = transition
  end

end

end
