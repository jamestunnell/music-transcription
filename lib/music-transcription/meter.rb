module Music
module Transcription

class Meter
  include Validatable
  
  attr_reader :measure_duration, :beat_duration, :beats_per_measure
  def initialize beats_per_measure, beat_duration
    @beats_per_measure = beats_per_measure
    @beat_duration = beat_duration
    @measure_duration = beats_per_measure * beat_duration
    
    @check_methods = [ :check_beats_per_measure, :check_beat_duration ]
  end
  
  def check_beats_per_measure
    unless @beats_per_measure > 0
      raise NonPositiveError, "beats per measure #{@beats_per_measure} is not positive"
    end
    
    unless @beats_per_measure.is_a?(Integer)
      raise NonIntegerError, "beats per measure #{@beats_per_measure} is not an integer"
    end
  end
    
  def check_beat_duration
    unless @beat_duration > 0
      raise NonPositiveError, "beat duration #{@beat_duration} is not positive"
    end
    
    unless @beat_duration > 0
      raise NonRationalError, "beat duration #{@beat_duration} is a rational"
    end
  end
  
  def ==(other)
    return (@beats_per_measure == other.beats_per_measure &&
      @beat_duration == other.beat_duration)
  end
end

end
end