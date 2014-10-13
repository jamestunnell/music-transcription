module Music
module Transcription

class Pitch
  def to_s(sharpit = false)
    letter = case semitone
    when 0 then "C"
    when 1 then sharpit  ? "C#" : "Db"
    when 2 then "D"
    when 3 then sharpit  ? "D#" : "Eb"
    when 4 then "E"
    when 5 then "F"
    when 6 then sharpit  ? "F#" : "Gb"
    when 7 then "G"
    when 8 then sharpit  ? "G#" : "Ab"
    when 9 then "A"
    when 10 then sharpit  ? "A#" : "Bb"
    when 11 then "B"
    end
    
    return letter + octave.to_s
  end
end

end
end