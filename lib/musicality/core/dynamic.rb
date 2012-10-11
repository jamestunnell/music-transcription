module Musicality

# Abstraction of a musical dynamic, for controlling loudness or softness in a
# part or score.
#
# @author James Tunnell
# 
# @!attribute [rw] loudness
#   @return [Float] Determine loudness or softness in a part or score.
#
# @!attribute [rw] transition_duration
#   @return [Rational] Duration of the transition from the current loudness to what
#                      is specified in this object.
#
# @!attribute [rw] transition_type
#   @return [Symbol] 
#
class Dynamic

  # a simple linear transition between dynamic levels
  TRANSITION_LINEAR = :dynamicTransitionLinear
  # a smooth natural 'S' transition between dynamic levels
  TRANSITION_SIGMOID = :dynamicTransitionSigmoid

  #allowed transitions between dynamic levels
  VALID_TRANSITIONS = 
  [
    TRANSITION_LINEAR,
    TRANSITION_SIGMOID
  ]

  attr_reader :loudness, :transition_duration, :transition_type
  
  # A new instance of Dynamic.
  # @param [Float] loudness The loudness or softness
  # @param [Rational] transition_duration The time to transition to the desired 
  #                                       loudness. Zero by default.
  # @param [Symbol] transition_type The type of transition to employ (see 
  #                                 VALID_DYNAMIC_TRANSITIONS for the permitted 
  #                                 transition types). Linear by default.
  def initialize loudness, transition_duration = 0.to_r, transition_type = TRANSITION_LINEAR
    self.loudness = loudness
    self.transition_duration = transition_duration
    self.transition_type = transition_type
  end
  
  # Set the dynamic loudness.
  # @param [Float] loudness The loudness or softness of the part.
  # @raise [ArgumentError] if loudness is not a Float.
  # @raise [RangeError] if loudness is outside the range 0.0..1.0.
  def loudness= loudness
    raise ArgumentError, "loudness is not a Float" if !loudness.is_a?(Float)
    raise RangeError, "loudness is outside the range 0.0..1.0" if !(0.0..1.0).include?(loudness)
  	@loudness = loudness
  end

  # Set the duration of transition to the desired loudness.
  # @param [Rational] transition_duration The time to transition to the desired loudness
  # @raise [ArgumentError] if transition_duration is not a Rational.
  # @raise [RangeError] if transition_duration is less than zero.
  def transition_duration= transition_duration
  	raise ArgumentError, "transition_duration is not a Rational" if !transition_duration.is_a?(Rational)
  	raise RangeError, "transition_duration is less than 0." if transition_duration < 0
  	@transition_duration = transition_duration
  end

  # Set the dynamic loudness.
  # @param [Float] loudness The loudness or softness of the part.
  # @raise [ArgumentError] if loudness is not a Float.
  # @raise [RangeError] if loudness is outside the range 0.0..1.0.
  def transition_type= transition_type
    raise ArgumentError, "transition_type #{transition_type} is not valid (one of #{VALID_TRANSITIONS.inspect}" if !VALID_TRANSITIONS.include?(transition_type)
    @transition_type = transition_type
  end
end

end
