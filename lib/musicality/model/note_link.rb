module Musicality
# Defines a relationship (tie, slur, legato, etc.) to a note with a certain pitch.
#
# @author James Tunnell
#
# @!attribute [rw] target_pitch
#   @return [Pitch] The pitch of the note which is being connected to.
#
# @!attribute [rw] relationship
#   @return [Symbol] The relationship between the current note and a consecutive
#                    note. Valid values are RELATIONSHIP_NONE, RELATIONSHIP_TIE,
#                    RELATIONSHIP_SLUR, RELATIONSHIP_LEGATO, RELATIONSHIP_GLISSANDO, 
#                    and RELATIONSHIP_PORTAMENTO.
#
class NoteLink
  include Hashmake::HashMakeable
  
  # no relationship with the following note
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
    :target_pitch => arg_spec(:reqd => false, :type => Pitch, :default => ->(){ Pitch.new }),
    :relationship => arg_spec(:reqd => false, :type => Symbol, :default => RELATIONSHIP_NONE, :validator => ->(a){ RELATIONSHIPS.include?(a)}),
  }

  attr_reader :target_pitch, :relationship
  
  # A new instance of NoteLink.
  # @param [Hash] args Hashed arguments. See ARG_SPECS for details about valid keys.
  def initialize args={}
    hash_make ARG_SPECS, args
  end
  
  # Produce an identical NoteLink object.
  def clone
    NoteLink.new(:target_pitch => @target_pitch.clone, :relationship => @relationship)
  end
  
  # Compare equality of two NoteLink objects.
  def ==(other)
    return (@target_pitch == other.target_pitch) && (@relationship == other.relationship)
  end

  # Set the pitch of the note being connected to.
  # @param [Pitch] target_pitch The pitch of the note being connected to.
  # @raise [ArgumentError] if target_pitch is not a Pitch.
  def target_pitch= target_pitch
    validate_arg ARG_SPECS[:target_pitch], target_pitch
    @target_pitch = target_pitch
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
  
end

# helper method to create a NoteLink object with GLISSANDO relationship.
def glissando_link pitch
  NoteLink.new(:pitch => pitch, :relationship => NoteLink::RELATIONSHIP_GLISSANDO)
end

# helper method to create a NoteLink object with LEGATO relationship.
def legato_link pitch
  NoteLink.new(:pitch => pitch, :relationship => NoteLink::RELATIONSHIP_LEGATO)
end

# helper method to create a NoteLink object with PORTAMENTO relationship.
def portamento_link pitch
  NoteLink.new(:pitch => pitch, :relationship => NoteLink::RELATIONSHIP_PORTAMENTO)
end

# helper method to create a NoteLink object with SLUR relationship.
def slur_link pitch
  NoteLink.new(:pitch => pitch, :relationship => NoteLink::RELATIONSHIP_SLUR)
end

# helper method to create a NoteLink object with TIE relationship.
def tie_link pitch
  NoteLink.new(:pitch => pitch, :relationship => NoteLink::RELATIONSHIP_TIE)
end

end
