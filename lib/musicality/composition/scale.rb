module Musicality

class Scale
  # diatonic scale modes
  
  IONIAN = IntervalVector.new([2,2,1,2,2,2,1])
  DORIAN = IntervalVector.new([2,1,2,2,2,1,2])
  PHRYGIAN = IntervalVector.new([1,2,2,2,1,2,2])
  LYDIAN = IntervalVector.new([2,2,2,1,2,2,1])
  MIXOLYDIAN = IntervalVector.new([2,2,1,2,2,1,2])
  AEOLIAN = IntervalVector.new([2,1,2,2,1,2,2])
  LOCRIAN = IntervalVector.new([1,2,2,1,2,2,2])
  
  DIATONIC_MODES = {
    1 => IONIAN,
    2 => DORIAN,
    3 => PHRYGIAN,
    4 => LYDIAN,
    5 => MIXOLYDIAN,
    6 => AEOLIAN,
    7 => LOCRIAN
  }
  
  MAJOR = IONIAN
  MINOR = AEOLIAN
  
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
