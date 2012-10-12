module Musicality

# Abstraction of a musical note. Contains values for pitch, duration, intensity, loudness, and seperation.
# The loudness, intensity, and seperation will be used to form the envelope profile for the note.
#
# @author James Tunnell
# 
# @!attribute [rw] pitch
#   @return [Pitch] The pitch of the note.
#
# @!attribute [rw] duration
#   @return [Rational] the duration of the note, in note lengths (e.g. 
#                      whole note => 1/1, quarter note => 1/4).
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
#                        same pitch (if such a note exists).
#
class Note

  attr_reader :pitch, :duration, :loudness, :intensity, :seperation
  attr_accessor :tie
  
  # A new instance of Note.
  # @param [Pitch] pitch The pitch of the note.
  # @param [Rational] duration The duration of the note, in note lengths
  #                   (e.g. whole note => 1/1, quarter note => 1/4).
  # @param [Hash] options Optional arguments. Valid keys are :loudness,
  #               :intensity, :seperation, and :tie.
  def initialize pitch, duration, options={}
    self.pitch = pitch
    self.duration = duration
  
    opts = {
      :loudness => 0.5,
      :intensity => 0.5,
      :seperation => 0.5,
      :tie => false,
    }.merge options
	  
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

  # Set the note duration.
  # @param [Numeric] duration The duration of the note.
  # @raise [ArgumentError] if duration is not a Rational and does not respond to :to_r.
  # @raise [RangeError] if duration is less than zero.
  def duration= duration
    if !duration.is_a?(Rational)
  	  raise ArgumentError, "duration is not a Rational and does not respond to :to_r" if !duration.respond_to?(:to_r)
  	  duration = duration.to_r
  	end

  	raise RangeError, "duration is less than 0." if duration < 0
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
