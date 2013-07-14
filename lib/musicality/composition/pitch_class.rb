module Musicality

class PitchClass
  MOD = Pitch::SEMITONES_PER_OCTAVE

  def self.from_i int
  end
end

class Pitch
  def to_pc
    pitch = clone
    
    if pitch.cent != 0
      pitch.round! # normalizes as well
    else
      pitch.normalize!
    end
    
    return pitch.semitone.to_pc
  end
end

end

class Fixnum
  def to_pc
    self % PitchClass::MOD
  end
end
