module Musicality 
# IntervalVector contants, for creating scales
module IntervalVectors
  CHROMATIC = IntervalVector.new([1,1,1,1,1,1,1,1,1,1,1])

  module Pentatonic
    MINOR = IntervalVector.new([3,2,2,3,2])
    MAJOR = IntervalVector.new(MINOR.intervals.rotate(1))
    EGYPTIAN = IntervalVector.new(MINOR.intervals.rotate(2))
    MINOR_BLUES = IntervalVector.new(MINOR.intervals.rotate(3))
    MAJOR_BLUES = IntervalVector.new(MINOR.intervals.rotate(4))

    PENTATONIC_MODES = {
      1 => MINOR,
      2 => MAJOR,
      3 => EGYPTIAN,
      4 => MINOR_BLUES,
      5 => MAJOR_BLUES
    }
  end

  module Hexatonic
    WHOLE_TONE = IntervalVector.new([2,2,2,2,2,2])
    AUGMENTED = IntervalVector.new([3,1,3,1,3,1])
    MYSTIC = PROMETHEAN = IntervalVector.new([2,2,2,3,1,2])
    BLUES = IntervalVector.new([3,2,1,1,3,2])
    TRITONE = PETRUSHKA = IntervalVector.new([1,3,2,1,3,2])
  end

  module Heptatonic
    # This is where the standard Major scale and its modes are found, among others.
    module Prima
      IONIAN = MAJOR = IntervalVector.new([2,2,1,2,2,2,1])
      DORIAN = IntervalVector.new(IONIAN.intervals.rotate(1))
      PHRYGIAN = IntervalVector.new(IONIAN.intervals.rotate(2))
      LYDIAN = IntervalVector.new(IONIAN.intervals.rotate(3))
      MIXOLYDIAN = IntervalVector.new(IONIAN.intervals.rotate(4))
      AEOLIAN = MINOR = IntervalVector.new(IONIAN.intervals.rotate(5))
      LOCRIAN = IntervalVector.new(IONIAN.intervals.rotate(6))
      
      MODES = {
        1 => IONIAN,
        2 => DORIAN,
        3 => PHRYGIAN,
        4 => LYDIAN,
        5 => MIXOLYDIAN,
        6 => AEOLIAN,
        7 => LOCRIAN
      }
    end

    module Secunda
      JAZZ_MINOR = MELODIC_MINOR = IntervalVector.new([2,1,2,2,2,2,1])
      PHRYGIAN_RAISED_SIXTH = IntervalVector.new(MELODIC_MINOR.intervals.rotate(1))
      LYDIAN_RAISED_FIFTH = IntervalVector.new(MELODIC_MINOR.intervals.rotate(2))
      ACOUSTIC = LYDIAN_DOMINANT = IntervalVector.new(MELODIC_MINOR.intervals.rotate(3))
      MAJOR_MINOR = IntervalVector.new(MELODIC_MINOR.intervals.rotate(4))
      HALF_DIMINISHED = IntervalVector.new(MELODIC_MINOR.intervals.rotate(5))
      ALTERED = IntervalVector.new(MELODIC_MINOR.intervals.rotate(6))

      MODES = {
        1 => MELODIC_MINOR,
        2 => PHRYGIAN_RAISED_SIXTH,
        3 => LYDIAN_RAISED_FIFTH,
        4 => ACOUSTIC,
        5 => MAJOR_MINOR,
        6 => HALF_DIMINISHED,
        7 => ALTERED
      }
    end

    module Other
      GYPSY = IntervalVector.new([1,3,1,2,1,3,1])
      HUNGARIAN = IntervalVector.new([2,1,3,1,1,3,1])
      PHRYGIAN_MAJOR = IntervalVector.new([1,3,1,2,1,2,2])
      SCALA_ENIGMATICA = IntervalVector.new([1,3,2,2,2,1,1])
    end
  end

  module Octatonic
    WHOLE_HALF = IntervalVector.new([2,1,2,1,2,1,2,1])
    HALF_WHOLE = IntervalVector.new(WHOLE_HALF.intervals.rotate(1))

    OCTATONIC_MODES = {
      1 => WHOLE_HALF,
      2 => HALF_WHOLE
    }
  end
end
end