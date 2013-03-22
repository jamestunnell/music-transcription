require 'hashmake'

module Musicality

# Abstraction of a musical note. Contains values for pitch, duration, attack, sustain, and seperation.
# The sustain, attack, and seperation will be used to form the envelope profile for the note.
#
# @author James Tunnell
# 
# @!attribute [rw] pitch
#   @return [Array] The pitch of the note.
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
  include Hashmake::HashMakeable
  attr_reader :pitch, :duration, :sustain, :attack, :seperation, :relationship

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

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :duration => arg_spec(:type => Numeric, :reqd => true),
    :pitch => arg_spec(:type => Pitch, :reqd => true),
    :sustain => arg_spec(:type => Numeric, :reqd => false, :validator => ->(a){ a.between?(0.0,1.0)}, :default => 0.5),
    :attack => arg_spec(:type => Numeric, :reqd => false, :validator => ->(a){ a.between?(0.0,1.0)}, :default => 0.5),
    :seperation => arg_spec(:type => Numeric, :reqd => false, :validator => ->(a){ a.between?(0.0,1.0)}, :default => 0.5),
    :relationship => arg_spec(:type => Symbol, :reqd => false, :validator => ->(a){ RELATIONSHIPS.include?(a)}, :default => RELATIONSHIP_NONE)
  }

  # A new instance of Note.
  # @param [Hash] args Hashed arguments. Required keys are :pitch, :duration, 
  #                    and :offset. Optional keys are :sustain, :attack, 
  #                    :seperation, and :tie.
  def initialize args={}
    hash_make ARG_SPECS, args
  end

  # Set the note pitch.
  # @param [Pitch] pitch The pitch of the note.
  # @raise [ArgumentError] if pitch is not a Pitch.
  def pitch= pitch
    validate_arg ARG_SPECS[:pitch], pitch
    @pitch = pitch
  end

  # Set the note duration.
  # @param [Numeric] duration The duration of the note.
  # @raise [ArgumentError] if duration is not a Numeric.
  # @raise [RangeError] if duration is negative or zero.
  def duration= duration
    validate_arg ARG_SPECS[:duration], duration
    @duration = duration
  end
  
  # Set the note sustain.
  # @param [Numeric] sustain The sustain of the note.
  # @raise [ArgumentError] if sustain is not a Numeric.
  # @raise [RangeError] if sustain is outside the range 0.0..1.0.
  def sustain= sustain
    validate_arg ARG_SPECS[:sustain], sustain
    @sustain = sustain
  end

  # Set the note attack.
  # @param [Numeric] attack The attack of the note.
  # @raise [ArgumentError] if attack is not a Numeric.
  # @raise [RangeError] if attack is outside the range 0.0..1.0.
  def attack= attack
    validate_arg ARG_SPECS[:attack], attack
    @attack = attack
  end

  # Set the note seperation.
  # @param [Numeric] seperation The seperation of the note.
  # @raise [ArgumentError] if seperation is not a Numeric.
  # @raise [RangeError] if seperation is outside the range 0.0..1.0.
  def seperation= seperation
    validate_arg ARG_SPECS[:seperation], seperation
    @seperation = seperation
  end
  

  # Set the note relationship.
  # @param [Symbol] relationship The relationship of the note to the following 
  #                  note (if applicable). Valid relationship are given by the 
  #                  RELATIONSHIPS constant.
  # @raise [ArgumentError] if relationship is not a valid relationship.
  def relationship= relationship
    validate_arg ARG_SPECS[:relationship], relationship
    @relationship = relationship
  end
  
  def clone
    Note.new(:pitch => @pitch.clone, :duration => @duration, :sustain => @sustain, :attack => @attack, :seperation => @seperation, :relationship => @relationship)
  end
end

end
