module Musicality

class Scale
  
  def initialize base_pitch_class, interval_vector
    @base_pitch_class = base_pitch_class
    @interval_vector = interval_vector
  end
  
  def pitch_at scale_offset, base_octave = 0
    intervals = @interval_vector.intervals

    semitone = @base_pitch_class
    if scale_offset > 0
      scale_offset.times do |i|
        semitone += intervals[i % intervals.count]
      end
    elsif scale_offset < 0
      -scale_offset.times do |i|
        semitone -= intervals[-i % intervals.count]
      end
    end
    Pitch.new(:semitone => semitone, :octave => base_octave)
  end
  
  def size
    @interval_vector.intervals.count
  end
end

class MajorScale < Scale
  def initialize base_pitch_class
    super(base_pitch_class, Scale::MAJOR)
  end
end

class MinorScale < Scale
  def initialize base_pitch_class
    super(base_pitch_class, Scale::MINOR)
  end
end
end
