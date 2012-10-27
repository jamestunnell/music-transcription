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

  attr_reader :loudness

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ :offset, :loudness ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :duration ]
  # default values for optional hashed arguments
  DEFAULT_OPTIONS = { :duration => 0.0 }
  
  # A new instance of Dynamic.
  # @param [Hash] args Hash arguments. Required keys are :loudness and :offset.
  #                    Optional key is :duration.
  def initialize args = {}
    raise ArgumentError, ":loudness key not present in args Hash" if !args.has_key?(:loudness)
    raise ArgumentError, ":offset key not present in args Hash" if !args.has_key?(:offset)
    
    self.loudness = args[:loudness]
  
    opts = DEFAULT_OPTIONS.merge args
    super opts[:offset], opts[:duration]
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
