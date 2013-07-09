require 'set'

module Musicality

# Each interval is the distance from the same pitch
class AbsoluteIntervalVector
  attr_reader :intervals
  def initialize intervals
    raise ArgumentError, "intervals is empty" if intervals.empty?
    @intervals = intervals
  end
  
  def to_pitches base_pitch
    pitches = []
    @intervals.each do |interval|
      offset_pitch = Pitch.new(:semitone => interval)
      pitches.push(base_pitch + offset_pitch)
    end
    return pitches
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
end

# Each interval is the distance from the previous pitch
class RelativeIntervalVector
  attr_reader :intervals
  def initialize intervals
    raise ArgumentError, "intervals is empty" if intervals.empty?
    @intervals = intervals
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
end

end