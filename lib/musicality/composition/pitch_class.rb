module Musicality

class PitchClass
  MOD = Pitch::SEMITONES_PER_OCTAVE

  def self.invert val
    (MOD - val.to_pc).to_pc
  end

  def self.to_s pc
    case pc
    when 0 then "C"
    when 1 then "C#"
    when 2 then "D"
    when 3 then "D#"
    when 4 then "E"
    when 5 then "F"
    when 6 then "F#"
    when 7 then "G"
    when 8 then "G#"
    when 9 then "A"
    when 10 then "A#"
    when 11 then "B"
    else
      "?"
    end
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

module Enumerable
  def to_pc_ary
    map {|value| value.to_pc }
  end
end
