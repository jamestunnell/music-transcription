module Musicality

# Abstraction of a musical slur, which connects notes to be played without 
# releases and without rearticulation.
#
# @author James Tunnell
# 
# @!attribute [r] notes
#   @return [Enumerable] The chord notes, contained in an Enumerable object (e.g. Array, Hash, etc.).
#
class Slur < NoteGroup
  
  # A new instance of Phrase.
  # @param [Enumerable] notes Enumerable containing at least two Note objects.
  def initialize notes
    super notes
  end
end

end
