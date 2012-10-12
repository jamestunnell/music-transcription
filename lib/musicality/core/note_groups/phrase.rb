module Musicality

# Abstraction of a musical phrase, which connects notes to be played without 
# releases but with rearticulation.
#
# @author James Tunnell
# 
# @!attribute [r] notes
#   @return [Enumerable] The chord notes, contained in an Enumerable object (e.g. Array, Hash, etc.).
#
class Phrase < NoteGroup
  
  # A new instance of Phrase.
  # @param [Enumerable] notes Enumerable containing at least two Note objects.
  def initialize notes
    super notes
  end
end

end
