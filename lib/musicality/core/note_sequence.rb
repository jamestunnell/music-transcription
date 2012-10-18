module Musicality

# A group of at least two notes. The group may exist for such musical constructs
# as a chord, phrase, slur, glissando, portamento, or tuplet.
#
# @author James Tunnell
# 
# @!attribute [r] notes
#   @return [Enumerable] Two or more notes contained in an Enumerable object 
#                        (e.g. Array, Hash, etc.).
#
class NoteSequence
  
  attr_reader :notes
  
  # A new instance of NoteSequence.
  # @param [Enumerable] notes Enumerable containing at least two Note objects
  # @raise [ArgumentError] if notes is not an Enumerable
  # @raise [ArgumentError] if notes is empty
  # @raise [ArgumentError] if notes has less than two objects
  # @raise [ArgumentError] if notes contains a non-Note
  def initialize notes
    raise ArgumentError, "notes is not an Enumerable" if !notes.is_a?(Enumerable)
    raise ArgumentError, "notes is empty" if notes.empty?
    raise ArgumentError, "notes has less than two Note objects" if notes.count < 2

    notes.each do |note|
      raise ArgumentError, "#{note} in notes is not a Note" if !note.is_a?(Note)
    end

    @notes = notes
  end
end

end
