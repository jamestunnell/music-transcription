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
  
  # Get a pitch by it's ordinal index. Modulo addressing will be used so any
  # Fixnum should work.
  def pitch_class_at i
    pcs = sort
    pcs[i % pcs.count]
  end
  
  def prev_pitch_class cur_pc, steps_back = 1
    pcs = sort
    less_than_cur = pcs.select {|pc| pc < cur_pc }
    if less_than_cur.any?
      return less_than_cur.last
    else
      greater_or_equal = pcs.select {|pc| pc >= cur_pc }
      return greater_or_equal.last
    end
  end
  
  def next_pitch_class cur_pc, steps_forward = 1
    pcs = sort
    greater_than_cur = pcs.select {|pc| pc > cur_pc }
    if greater_than_cur.any?
      return greater_than_cur.first
    else
      less_or_equal = pcs.select {|pc| pc <= cur_pc }
      return less_or_equal.first
    end
  end
  
  # Build an IntervalVector, which will represent the differences (intervals)
  # between all the pitch classes. The number of intervals will equal the number
  # of pitch classes, and their sum will be 12.
  def to_interval_vector
    pcs = sort
    intervals = [ ]
    for i in 1...pcs.count
      intervals.push(pcs[i] - pcs[i-1])
    end
    intervals.push(12 + pcs.first - pcs.last)
    IntervalVector.new(intervals)
  end
end

def pcs arg = []
  PitchClassSet.new(arg)
end

end