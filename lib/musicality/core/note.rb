module Musicality

# Abstraction of a musical note. Contains values for pitch, duration, intensity, loudness, and seperation.
# The loudness, intensity, and seperation will be used to form the envelope profile for the note.
#
# @author James Tunnell
# 
# @!attribute [r] pitch
#   @return [Pitch] The pitch of the note.
# @!attribute [r] duration
#   @return [Rational] the duration of the note, in note lengths (e.g. whole note => 1/1, quarter note => 1/4).
# @!attribute [r] intensity
#   @return [Float] Affects the loudness (envelope) during the attack portion of the note. From 0.0 (less attack) to 1.0 (more attack).
# @!attribute [r] loudness
#   @return [Float] Affects the loudness (envelope) during the sustain portion of the note. From 0.0 (less sustain) to 1.0 (more sustain).
# @!attribute [r] seperation
#   @return [Float] Shift the note release towards or away the beginning of the note. From 0.0 (towards end of the note) to 1.0 (towards beginning of the note).
class Note

  attr_reader :pitch, :duration, :loudness, :intensity, :seperation
  
  # A new instance of Note.
  # @param [Pitch] pitch The pitch of the note.
  # @param [Rational] duration The duration of the note, in note lengths (e.g. whole note => 1/1, quarter note => 1/4).
  # @param [Hash] options Optional arguments. Valid keys are :loudness, :intensity, and :seperation 
  def initialize pitch, duration, options={}
    raise ArgumentError, "pitch is not a Pitch" if !pitch.is_a?(Pitch)
    raise ArgumentError, "duration is not a Rational" if !duration.is_a?(Rational)    

	  @pitch = pitch
	  @duration = duration
	
	  opts = {
	    :loudness => 0.5,
	    :intensity => 0.5,
	    :seperation => 0.5
	  }.merge options
	  
	  # The loudness, intensity, and seperation will be used to form the envelope profile for the note.

    @loudness = opts[:loudness]
    raise ArgumentError, "options[:loudness] is not a Float" if !@loudness.is_a?(Float)
    raise RangeError, "options[:loudness] is outside the range 0.0..1.0" if !(0.0..1.0).include?(@loudness)

	  @intensity = opts[:intensity]	
    raise ArgumentError, "options[:intensity] is not a Numeric" if !@intensity.is_a?(Float)
    raise RangeError, "options[:intensity] is outside the range 0.0..1.0" if !(0.0..1.0).include?(@intensity)
	    
	  @seperation = opts[:seperation]
    raise ArgumentError, "options[:seperation] is not a Numeric" if !@seperation.is_a?(Float)
    raise RangeError, "options[:seperation] is outside the range 0.0..1.0" if !(0.0..1.0).include?(@seperation)
  end
end

end
