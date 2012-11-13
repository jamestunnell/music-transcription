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
# @!attribute [rw] relationship
#   @return [Symbol] The relationship between the current note and a consecutive
#                    note. Valid values are NONE, TIE, SLUR, LEGATO, GLISSANDO, 
#                    and PORTAMENTO.
#
class Note
  include HashMake
  attr_reader :pitches, :duration, :sustain, :attack, :seperation, :relationship

  # no relationship to the following note
  RELATIONSHIP_NONE = :none
  # tie to the following note
  RELATIONSHIP_TIE = :tie
  # play notes continuously and don't rearticulate
  RELATIONSHIP_SLUR = :slur
  # play notes continuously and do rearticulate
  RELATIONSHIP_LEGATO = :legato
  # play an uninterrupted slide through a series of consecutive tones to the next note.
  RELATIONSHIP_GLISSANDO = :glissando
  # play an uninterrupted glide to the next note.
  RELATIONSHIP_PORTAMENTO = :portamento
  
  # a list of valid note relationships
  RELATIONSHIPS = [
    RELATIONSHIP_NONE,
    RELATIONSHIP_TIE,
    RELATIONSHIP_SLUR,
    RELATIONSHIP_LEGATO,
    RELATIONSHIP_GLISSANDO,
    RELATIONSHIP_PORTAMENTO
  ]

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:duration, Numeric),
               spec_arg_array(:pitches, Pitch) ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg(:sustain, Numeric, ->{ 0.5 }),
               spec_arg(:attack, Numeric, ->{ 0.5 }),
               spec_arg(:seperation, Numeric, ->{ 0.5 }),
               spec_arg(:relationship, Symbol, ->{ RELATIONSHIP_NONE }) ]

  # A new instance of Note.
  # @param [Hash] args Hashed arguments. Required keys are :pitches, :duration, 
  #                    and :offset. Optional keys are :sustain, :attack, 
  #                    :seperation, and :tie.
  def initialize args={}
    process_args args
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
    raise ArgumentError, "duration #{duration} is not a Numeric" if !duration.is_a?(Numeric)
  	raise RangeError, "duration #{duration} is negative or zero." if duration <= 0.0  	
  	@duration = duration
  end
  
  # Set the note sustain.
  # @param [Numeric] sustain The sustain of the note.
  # @raise [ArgumentError] if sustain is not a Numeric.
  # @raise [RangeError] if sustain is outside the range 0.0..1.0.
  def sustain= sustain
    raise ArgumentError, "sustain is not a Numeric" if !sustain.is_a?(Numeric)
    raise RangeError, "sustain is outside the range 0.0..1.0" if !sustain.between?(0.0,1.0)
  	@sustain = sustain
  end

  # Set the note attack.
  # @param [Numeric] attack The attack of the note.
  # @raise [ArgumentError] if attack is not a Numeric.
  # @raise [RangeError] if attack is outside the range 0.0..1.0.
  def attack= attack
    raise ArgumentError, "attack is not a Numeric" if !attack.is_a?(Numeric)
    raise RangeError, "attack is outside the range 0.0..1.0" if !attack.between?(0.0,1.0)
	@attack = attack
  end

  # Set the note seperation.
  # @param [Numeric] seperation The seperation of the note.
  # @raise [ArgumentError] if seperation is not a Numeric.
  # @raise [RangeError] if seperation is outside the range 0.0..1.0.
  def seperation= seperation
    raise ArgumentError, "seperation is not Numeric" if !seperation.is_a?(Numeric)
    raise RangeError, "seperation is outside the range 0.0..1.0" if !seperation.between?(0.0,1.0)
    @seperation = seperation
  end
  

  # Set the note relationship.
  # @param [Symbol] relationship The relationship of the note to the following 
  #                  note (if applicable). Valid relationship are given by the 
  #                  RELATIONSHIPS constant.
  # @raise [ArgumentError] if relationship is not a valid relationship.
  def relationship= relationship
    raise ArgumentError, "relationship is not valid (not found in RELATIONSHIPS)" if !RELATIONSHIPS.include?(relationship)
    @relationship = relationship
  end
end

end
