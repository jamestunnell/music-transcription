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
  def initialize notes, modifier = Rational(2,3)
    super notes
    self.modifier = modifier
  end
  
  # Set the duration modifier.
  # @param [Numeric] modifier The duration modifier for tuplet notes.
  # @raise [ArgumentError] if modifier is not a Rational and does not respond to :to_r.
  def modifier= modifier
    if !modifier.is_a?(Rational)
  	  raise ArgumentError, "modifier is not a Rational and does not respond to :to_r" if !modifier.respond_to?(:to_r)
  	  modifier = modifier.to_r
  	end

    @modifier = modifier
  end
end

end
