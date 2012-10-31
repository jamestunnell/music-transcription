module Musicality

# Abstraction of a musical note. Contains values for pitches, duration, intensity, loudness, and seperation.
# The loudness, intensity, and seperation will be used to form the envelope profile for the note.
#
# @author James Tunnell
# 
# @!attribute [rw] pitches
#   @return [Array] The pitches of the note.
#
# @!attribute [rw] duration
#   @return [Rational] The duration of the note in note lengths.
#
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
#                        same pitches (if such a note exists).
class Note

  attr_reader :pitches, :duration, :loudness, :intensity, :seperation
  attr_accessor :tie

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ :duration, :pitches ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :loudness, :intensity, :seperation, :tie ]
  # default values for optional hashed arguments
  OPTIONAL_ARG_DEFAULTS = { :loudness => 0.5, :intensity => 0.5, 
                      :seperation => 0.5, :tie => false }

  # A new instance of Note.
  # @param [Hash] args Hashed arguments. Required keys are :pitches, :duration, 
  #                    and :offset. Optional keys are :loudness, :intensity, 
  #                    :seperation, and :tie.
  def initialize args={}
    raise ArgumentError, ":pitches key not present in args Hash" if !args.has_key?(:pitches)
    raise ArgumentError, ":duration key not present in args Hash" if !args.has_key?(:duration)
    
    self.pitches = args[:pitches]
    self.duration = args[:duration]
  
    opts = OPTIONAL_ARG_DEFAULTS.merge args
	  
    # The loudness, intensity, and seperation will be used to form the envelope profile for the note.

    self.loudness = opts[:loudness]
    self.intensity = opts[:intensity]	
    self.seperation = opts[:seperation]
    self.tie = opts[:tie]
  end

  # Set the note pitches.
  # @param [Array] pitches The pitches of the note.
  # @raise [ArgumentError] if pitches is not an Array.
  # @raise [ArgumentError] if pitches contains a non-Pitch.
  def pitches= pitches
    raise ArgumentError, "pitches is not an Array" if !pitches.is_a?(Array)
    pitches.each do |pitch|
      raise ArgumentError, "pitch #{pitch} is not a Pitch" if !pitch.is_a?(Pitch)
    end
    
    @pitches = pitches
  end

  # Set the note duration.
  # @param [Numeric] duration The duration of the note.
  # @raise [ArgumentError] if duration is not a Numeric.
  # @raise [RangeError] if duration is negative or zero.
  def duration= duration
    raise ArgumentError, "duration is not a Numeric" if !duration.is_a?(Numeric)
  	raise RangeError, "duration is negative or zero." if duration <= 0.0  	
  	@duration = duration
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
