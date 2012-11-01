module Musicality

# Abstraction of a musical note. Contains values for pitches, duration, attack, sustain, and seperation.
# The sustain, attack, and seperation will be used to form the envelope profile for the note.
#
# @author James Tunnell
# 
# @!attribute [rw] pitches
#   @return [Array] The pitches of the note.
#
# @!attribute [rw] duration
#   @return [Rational] The duration of the note in note lengths.
#
# @!attribute [rw] attack
#   @return [Numeric] The amount of attack, from 0.0 (less) to 1.0 (more).
#                     Attack controls how quickly a note's loudness increases
#                     at the start.
#
# @!attribute [rw] sustain
#   @return [Numeric] The amount of sustain, from 0.0 (less) to 1.0 (more).
#                     Sustain controls how much the note's loudness is 
#                     sustained after the attack.
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

  attr_reader :pitches, :duration, :sustain, :attack, :seperation
  attr_accessor :tie

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ :duration, :pitches ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :sustain, :attack, :seperation, :tie ]
  # default values for optional hashed arguments
  OPTIONAL_ARG_DEFAULTS = { :sustain => 0.5, :attack => 0.5, 
                      :seperation => 0.5, :tie => false }

  # A new instance of Note.
  # @param [Hash] args Hashed arguments. Required keys are :pitches, :duration, 
  #                    and :offset. Optional keys are :sustain, :attack, 
  #                    :seperation, and :tie.
  def initialize args={}
    raise ArgumentError, ":pitches key not present in args Hash" if !args.has_key?(:pitches)
    raise ArgumentError, ":duration key not present in args Hash" if !args.has_key?(:duration)
    
    self.pitches = args[:pitches]
    self.duration = args[:duration]
  
    opts = OPTIONAL_ARG_DEFAULTS.merge args
	  
    # The sustain, attack, and seperation will be used to form the envelope profile for the note.

    self.sustain = opts[:sustain]
    self.attack = opts[:attack]	
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
  
  # Set the note sustain.
  # @param [Numeric] sustain The sustain of the note.
  # @raise [ArgumentError] if sustain is not a Numeric.
  # @raise [RangeError] if sustain is outside the range 0.0..1.0.
  def sustain= sustain
    raise ArgumentError, "sustain is not a Numeric" if !sustain.is_a?(Numeric)
    raise RangeError, "sustain is outside the range 0.0..1.0" if !(0.0..1.0).include?(sustain)
  	@sustain = sustain
  end

  # Set the note attack.
  # @param [Numeric] attack The attack of the note.
  # @raise [ArgumentError] if attack is not a Numeric.
  # @raise [RangeError] if attack is outside the range 0.0..1.0.
  def attack= attack
    raise ArgumentError, "attack is not a Numeric" if !attack.is_a?(Numeric)
    raise RangeError, "attack is outside the range 0.0..1.0" if !(0.0..1.0).include?(attack)
	@attack = attack
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
