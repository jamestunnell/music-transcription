module Musicality

# Abstraction of a musical note. Contains values for pitch, duration, intensity, loudness, and seperation.
# The loudness, intensity, and seperation will be used to form the envelope profile for the note.
#
# @author James Tunnell
# 
# @!attribute [r] pitch
#   @return [Pitch] the pitch of the note
# @!attribute [r] duration
#   @return [Rational] the duration of the note, in note lengths (e.g. whole note => 1/1, quarter note => 1/4)
# @!attribute [r] intensity
#   @return [Float] affects the loudness (envelope) during the attack portion of the note. From 0.0 (less attack) to 1.0 (more attack).
# @!attribute [r] loudness
#   @return [Float] affects the loudness (envelope) during the sustain portion of the note. From 0.0 (less sustain) to 1.0 (more sustain).
# @!attribute [r] seperation
#   @return [Float] Shift the note release towards or away the beginning of the note. From 0.0 (towards end of the note) to 1.0 (towards beginning of the note).
class Note

  attr_reader :pitch, :duration, :loudness, :intensity, :seperation
  
  # A new instance of Note.
  # @param [Hash] args hash-based initialization arguments. Valid keys are :pitch, :duration, :intensity, and :seperation 
  def initialize args={}
    if args[:pitch]
	  raise ArgumentError, "args[:pitch] is nil" if args[:pitch].nil?
	  raise ArgumentError, "args[:pitch] is not a Pitch" if !args[:pitch].is_a?(Pitch)
	end
	@pitch = args[:pitch] || Pitch.new
		
	if args[:duration]
	  raise ArgumentError, "args[:duration] is nil" if args[:duration].nil?
	  raise ArgumentError, "args[:duration] is not a Duration" if !args[:duration].is_a?(Rational)
	end
	@duration = args[:duration] || 1.to_r
	
	# The loudness, intensity, and seperation will be used to form the envelope profile for the note.

	if args[:loudness]
	  raise ArgumentError, "args[:loudness] is not a Numeric" if !args[:loudness].is_a?(Numeric)
	  raise RangeError, "args[:loudness] is outside the range 0.0..1.0" if !(0.0..1.0).include?(args[:loudness])
	end
	@loudness = args[:loudness] || 0.5
	
	if args[:intensity]
	  raise ArgumentError, "args[:intensity] is not a Numeric" if !args[:intensity].is_a?(Numeric)
	  raise RangeError, "args[:intensity] is outside the range 0.0..1.0" if !(0.0..1.0).include?(args[:intensity])
	end
	@intensity = args[:intensity] || 0.5
	  
	if args[:seperation]
	  raise ArgumentError, "args[:seperation] is not a Numeric" if !args[:seperation].is_a?(Numeric)
	  raise RangeError, "args[:seperation] is outside the range 0.0..1.0" if !(0.0..1.0).include?(args[:seperation])
	end
	@seperation = args[:seperation] || 0.5
  end
end

end