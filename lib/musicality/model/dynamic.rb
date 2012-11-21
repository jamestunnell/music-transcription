module Musicality

# Abstraction of a musical dynamic, for controlling loudness or softness in a
# part or score.
#
# @author James Tunnell
# 
# @!attribute [rw] loudness
#   @return [Float] Determine loudness or softness in a part or score.
#
class Dynamic < Event
  include HashMake
  attr_reader :loudness

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [
    spec_arg(:offset, Numeric, ->(a){ a.between?(Event::MIN_OFFSET, Event::MAX_OFFSET) }),
    spec_arg(:loudness, Numeric, ->(a){ a.between?(0.0,1.0) } )
  ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [
    spec_arg(:duration, Numeric, ->(a){ a >= 0.0 }, 0.0)
  ]
  
  # A new instance of Dynamic.
  # @param [Hash] args Hash arguments. Required keys are :loudness and :offset.
  #                    Optional key is :duration.
  def initialize args = {}
    process_args args
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
end

end
