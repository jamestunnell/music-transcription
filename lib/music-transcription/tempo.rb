module Music
module Transcription

# Represent the musical tempo, with beats ber minute and beat duration.
class Tempo
  include Comparable
  attr_reader :beats_per_minute, :beat_duration
  
  def initialize beats_per_minute, beat_duration = Rational(1,4)
    @beats_per_minute = beats_per_minute
    @beat_duration = beat_duration
  end
  
  def notes_per_second
    (@beats_per_minute * @beat_duration) / 60.0
  end
  
  def between? a, b
    notes_per_second.between? a, b
  end
  
  def <=>(other)
    if other.is_a? Tempo
      notes_per_second <=> other.notes_per_second
    else
      notes_per_second <=> other
    end
  end
end

end
end
