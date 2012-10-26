module Musicality

# Abstraction of a musical tuplet: a sequence of notes played with a modified 
# note duration. For example, a common tuplet is the triplet, whose notes are 
# each played at 2/3 their duration.
#
# @author James Tunnell
#
class Tuplet < NoteSequence
  
  attr_reader :modifier
  
  # A new instance of Tuplet.
  # @param [Enumerable] notes Enumerable containing Note objects.
  # @param [Numeric] modifier Determines how much note duration is modified. 
  #                           Default is 2/3 (triplet)
  def initialize notes, modifier = 2.0 / 3.0
    super notes
    self.modifier = modifier
  end
  
  # Set the duration modifier.
  # @param [Numeric] modifier The duration modifier for tuplet notes.
  # @raise [ArgumentError] if modifier is not a Numeric
  def modifier= modifier
    raise ArgumentError, "modifier is not a Numeric" if !modifier.is_a?(Numeric)
    @modifier = modifier
  end
end

end
