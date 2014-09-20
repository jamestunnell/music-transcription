module Music
module Transcription

class Score
  attr_reader :start_meter, :start_tempo, :parts, :program, :meter_changes, :tempo_changes
  
  def initialize start_meter, start_tempo, meter_changes: {}, tempo_changes: {}, parts: {}, program: Program.new
    @start_meter = start_meter
    @start_tempo = start_tempo
    @meter_changes = meter_changes
    @tempo_changes = tempo_changes
    @parts = parts
    @program = program
  end

  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  def ==(other)
    return @start_meter == other.start_meter && 
    @start_tempo == other.start_tempo &&
    @meter_changes == other.meter_changes &&
    @tempo_changes == other.tempo_changes &&
    @parts == other.parts &&
    @program == other.program
  end
    
  def duration
    @parts.map {|p| p.duration }.max
  end
end

end
end
