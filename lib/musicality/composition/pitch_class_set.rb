require 'set'

module Musicality

# Represent a pitch class set, which is a music theory concept for describing
# interval relationships, independent of which octave the interval appears in.
# In a pitch class set, C0 and C1 both have a value of 0.
class PitchClassSet < Set
  
  def self.pitch_to_pc pitch
    pitch = pitch.clone
    
    if pitch.cent != 0
      pitch.round! # normalizes as well
    else
      pitch.normalize!
    end
    
    return pitch.semitone
  end
    
  def initialize pitches = []
    super(pitches)
  end
  
  alias :original_add :add
  def add item
    if item.is_a? Pitch
      original_add(PitchClassSet.pitch_to_pc item)
    elsif item.is_a? Fixnum
      original_add(item % 12)
    else
      raise ArgumentError, "item #{item} is not a Fixnum or Pitch object"
    end
  end
  
end

def pcs arg = []
  PitchClassSet.new(arg)
end

end