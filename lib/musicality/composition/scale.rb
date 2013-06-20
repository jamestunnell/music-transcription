require 'set'

module Musicality

# 
class Scale
  
  attr_reader :intervals
  def initialize intervals
    raise ArgumentError, "intervals is empty" if intervals.empty?
    @intervals = intervals
  end
  
  def apply_intervals base_pitch
    pitches = []
    @intervals.each do |interval|
      offset_pitch = Pitch.new(:semitone => interval)
      pitches.push(base_pitch + offset_pitch)
    end
    return pitches
  end
end

end