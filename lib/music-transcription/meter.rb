module Music
module Transcription

class Meter
  
  attr_reader :measure_duration, :beat_duration, :beats_per_measure
  def initialize beats_per_measure, beat_duration
    @beats_per_measure = beats_per_measure
    @beat_duration = beat_duration
    @measure_duration = beats_per_measure * beat_duration
  end
end

end
end