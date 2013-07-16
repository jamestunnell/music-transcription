require 'set'

module Musicality

class IntervalVector
  attr_reader :intervals
  def initialize intervals
    raise ArgumentError, "intervals is empty" if intervals.empty?
    @intervals = intervals
  end
  
  def ==(other)
    @intervals == other.intervals
  end

  def clone
    return Marshal.load(Marshal.dump(self))
  end
  
  def inverse
    self.clone.invert!
  end
  
  def invert!
    @intervals.map! {|interval| -interval }
    return self
  end

  def to_pitches base_pitch
    pitches = [base_pitch + Pitch.new(:semitone => intervals.first)]
    @intervals[1..-1].each do |interval|
      pitches.push pitches.last + Pitch.new(:semitone => interval)
    end
    pitches
  end
  
  def to_pcs base_pc
    pcs = [base_pc + intervals.first]
    @intervals[1..-1].each do |interval|
      pcs.push pcs.last + offset_pitch
    end
    pcs.to_pcs
  end

end

end

class Array
  def to_iv
    Musicality::IntervalVector.new(self)
  end
end