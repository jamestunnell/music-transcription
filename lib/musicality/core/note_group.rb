module Musicality

# A group of at least two notes. The group may exist for such musical constructs
# as a slur, glissando, portamento, or tuplet.
#
# @author James Tunnell
# 
# @!attribute [r] notes
#   @return [Enumerable] Two or more notes contained in an Enumerable object (e.g. Array, Hash, etc.).
#
class NoteGroup

  # a chord is played at once or arpeggiated and sustained
  NOTE_GROUP_CHORD = :noteGroupChord
  # a glissando connects notes with all the pitches in between (in discrete fashion)
  NOTE_GROUP_GLISSANDO = :noteGroupGlissando
  # a phrase connects notes (no releases) with rearticulation
  NOTE_GROUP_PHRASE = :noteGroupPhrase
  # a glissando connects notes with all the pitches in between (in continuous fashion)  
  NOTE_GROUP_PORTAMENTO = :noteGroupPortamento
  # a phrase connects notes (no releases) without rearticulation
  NOTE_GROUP_SLUR = :noteGroupSlur
  # a tuple presents notes to be played in an off-meter fashion (e.g. a triplet).
  NOTE_GROUP_TUPLE = :noteGroupTuple

  # The valid (accepted) note groups
  VALID_GROUP_TYPES = [ 
    NOTE_GROUP_CHORD,
    NOTE_GROUP_GLISSANDO, 
    NOTE_GROUP_PHRASE, 
    NOTE_GROUP_PORTAMENTO, 
    NOTE_GROUP_SLUR, 
    NOTE_GROUP_TUPLE 
  ]

  attr_reader :notes, :type
  
  # A new instance of NoteGroup.
  # @param [Enumerable] notes Enumerable containing at least two Note objects
  def initialize notes, type
    raise ArgumentError, "notes is not an Enumerable" if !notes.is_a?(Enumerable)
    raise ArgumentError, "notes is empty" if notes.empty?
    raise ArgumentError, "notes has less than two Note objects" if notes.length < 2

    notes.each do |note|
      raise ArgumentError, "#{note} in notes is not a Note" if !note.is_a?(Note)
    end

    @notes = notes
        
    raise ArgumentError, "type #{type} is not valid (one of #{VALID_GROUP_TYPES.inspect}" if !VALID_GROUP_TYPES.include?(type)
    @type = type
  end
end

end
