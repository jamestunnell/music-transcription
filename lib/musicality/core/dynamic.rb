module Musicality

# Abstraction of a musical dynamic, for controlling loudness or softness in a
# part or score.
#
# @author James Tunnell
# 
# @!attribute [rw] loudness
#   @return [Float] Determine loudness or softness in a part or score.
#
# @!attribute [rw] transition
#   @return [Transition] Determine the length and shape of transition
##
class Dynamic

  attr_reader :loudness, :transition
  
  # A new instance of Dynamic.
  # @param [Float] loudness The loudness or softness
  # @param [Rational] transition_duration The time to transition to the desired 
  #                                       loudness. Zero by default.
  # @param [Symbol] transition_type The type of transition to employ (e.g. 
  #                                 linear, sigmoid). See VALID_TRANSITIONS for
  #                                 the permitted types). Linear by default.
  def initialize loudness, transition_duration = 0.to_r, transition_type = Transition::SHAPE_LINEAR
    self.loudness = loudness
    self.transition = Transition.new transition_duration, transition_type
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

  # Set the dynamic transition.
  # @param [Transition] transition The transition to this dynamic.
  # @raise [ArgumentError] if transition is not a Transition.
  def transition= transition
    raise ArgumentError, "transition is not a Transition" if !transition.is_a?(Transition)
  	@transition = transition
  end

end

end
