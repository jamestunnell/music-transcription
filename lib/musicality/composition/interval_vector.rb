require 'set'

module Musicality

class IntervalVector
  attr_reader :intervals
  def initialize intervals
    raise ArgumentError, "intervals is empty" if intervals.empty?
    @intervals = intervals
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
    pitches = []
    @intervals.each do |interval|
      offset_pitch = Pitch.new(:semitone => interval)
      if pitches.empty?
        pitches.push(base_pitch + offset_pitch)
      else
        pitches.push(pitches.last + offset_pitch)
      end
    end
    return pitches
  end
  
  def to_pitch_class_set base_pitch
    PitchClassSet.new to_pitches(base_pitch)
  end

end

end