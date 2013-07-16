module Musicality

class PitchClass
  MOD = Pitch::SEMITONES_PER_OCTAVE

  def self.invert val
    (MOD - val.to_pc).to_pc
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
    self % Musicality::PitchClass::MOD
  end
end

class Array
  def to_pcs
    map {|value| value.to_pc}
  end
end

class Set
  def to_pcs
    map {|value| value.to_pc}
  end
end
