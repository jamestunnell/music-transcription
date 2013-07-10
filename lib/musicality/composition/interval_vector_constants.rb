module Musicality
  
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
  
  MAJOR = NATURAL_MAJOR = IONIAN
  MINOR = NATURAL_MINOR = AEOLIAN
  
  # harmonic minor scale modes
  
  HARMONIC_MINOR = IntervalVector.new([2,1,2,2,1,3,1])
  MELODIC_MINOR = IntervalVector.new([2,1,2,2,2,2,1])
  
end