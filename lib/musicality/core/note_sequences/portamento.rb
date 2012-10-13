module Musicality

# Abstraction of a musical portamento. Contains a collection of notes, all of the
# pitches between which are to be played in a continuous manner (if instrument 
# allows).
#
# @author James Tunnell
# 
# @!attribute [r] notes
#   @return [Enumerable] The chord notes, contained in an Enumerable object (e.g. Array, Hash, etc.).
#
class Portamento < NoteSequence
  
  # A new instance of Portamento.
  # @param [Enumerable] notes Enumerable containing at least two Note objects.
  def initialize notes
    super notes
  end
end

end
