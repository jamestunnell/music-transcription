module Musicality

# Abstraction of a musical note. Contains values for pitch, duration, intensity, loudness, and seperation.
# The loudness, intensity, and seperation will be used to form the envelope profile for the note.
#
# @author James Tunnell
# 
# @!attribute [rw] pitch
#   @return [Pitch] The pitch of the note.

# @!attribute [rw] intensity
#   @return [Numeric] Affects the loudness (envelope) during the attack 
#                   portion of the note. From 0.0 (less attack) to 1.0 
#                   (more attack).
#
# @!attribute [rw] loudness
#   @return [Numeric] Affects the loudness (envelope) during the sustain 
#                   portion of the note. From 0.0 (less sustain) to 1.0 
#                   (more sustain).
#
# @!attribute [rw] seperation
#   @return [Numeric] Shift the note release towards or away the beginning
#                   of the note. From 0.0 (towards end of the note) to 
#                   1.0 (towards beginning of the note).
#
# @!attribute [rw] tie
#   @return [true/false] Indicates the note should be played 
#                        continuously with the following note of the 
#                        same pitch (if such a note exists).
class Note < Event

  attr_reader :pitch, :loudness, :intensity, :seperation
  attr_accessor :tie

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ :offset, :duration, :pitch ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :loudness, :intensity, :seperation, :tie ]
  # default values for optional hashed arguments
  DEFAULT_OPTIONS = { :loudness => 0.5, :intensity => 0.5, 
                      :seperation => 0.5, :tie => false }

  # A new instance of Note.
  # @param [Hash] args Hashed arguments. Required keys are :pitch, :duration, 
  #                    and :offset. Optional keys are :loudness, :intensity, 
  #                    :seperation, and :tie.
  def initialize args={}
    raise ArgumentError, ":pitch key not present in args Hash" if !args.has_key?(:pitch)
    raise ArgumentError, ":duration key not present in args Hash" if !args.has_key?(:duration)
    raise ArgumentError, ":offset key not present in args Hash" if !args.has_key?(:offset)
    
    self.pitch = args[:pitch]
    super args[:offset], args[:duration]
  
    opts = DEFAULT_OPTIONS.merge args
	  
    # The loudness, intensity, and seperation will be used to form the envelope profile for the note.

    self.loudness = opts[:loudness]
    self.intensity = opts[:intensity]	
    self.seperation = opts[:seperation]
    self.tie = opts[:tie]
  end
  
  # Set the note pitch.
  # @param [Pitch] pitch The pitch of the note.
  # @raise [ArgumentError] if pitch is not a Pitch.
  def pitch= pitch
    raise ArgumentError, "pitch is not a Pitch" if !pitch.is_a?(Pitch)
    @pitch = pitch
  end

  # Set the note loudness.
  # @param [Numeric] loudness The loudness of the note.
  # @raise [ArgumentError] if loudness is not a Numeric.
  # @raise [RangeError] if loudness is outside the range 0.0..1.0.
  def loudness= loudness
    raise ArgumentError, "loudness is not a Numeric" if !loudness.is_a?(Numeric)
    raise RangeError, "loudness is outside the range 0.0..1.0" if !(0.0..1.0).include?(loudness)
  	@loudness = loudness
  end

  # Set the note intensity.
  # @param [Numeric] intensity The intensity of the note.
  # @raise [ArgumentError] if intensity is not a Numeric.
  # @raise [RangeError] if intensity is outside the range 0.0..1.0.
  def intensity= intensity
    raise ArgumentError, "intensity is not a Numeric" if !intensity.is_a?(Numeric)
    raise RangeError, "intensity is outside the range 0.0..1.0" if !(0.0..1.0).include?(intensity)
	@intensity = intensity
  end

  # Set the note seperation.
  # @param [Numeric] seperation The seperation of the note.
  # @raise [ArgumentError] if seperation is not a Numeric.
  # @raise [RangeError] if seperation is outside the range 0.0..1.0.
  def seperation= seperation
    raise ArgumentError, "seperation is not Numeric" if !seperation.is_a?(Numeric)
    raise RangeError, "seperation is outside the range 0.0..1.0" if !(0.0..1.0).include?(seperation)
    @seperation = seperation
  end
end

end
