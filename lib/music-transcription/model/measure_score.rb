module Music
module Transcription

class MeasureScore < NoteScore
  attr_accessor :start_meter, :meter_changes
  
  def initialize start_meter, start_tempo, meter_changes: {}, tempo_changes: {}, parts: {}, program: Program.new
    @start_meter = start_meter
    @meter_changes = meter_changes
    
    super(start_tempo, tempo_changes: tempo_changes, program: program, parts: parts)
    yield(self) if block_given?
  end
  
  def check_methods
    super() + [:check_meter_changes]
  end
  
  def validatables
    super() + [ @start_meter ] + @meter_changes.values +
      @meter_changes.values.map {|v| v.value}
  end
  
  def check_meter_changes
    nonzero_duration = @meter_changes.select {|k,v| v.duration != 0 }
    if nonzero_duration.any?
      raise NonZeroError, "meter changes #{nonzero_duration} have non-zero duration"
    end
  end
  
  def ==(other)
    return super() && @start_meter == other.start_meter &&
      @meter_changes == other.meter_changes
  end
    
  # Convert to NoteScore object by first converting measure-based offsets to
  # note-based offsets, and eliminating the use of meters. Also, tempo is
  # converted from beats-per-minute to notes-per-minute.
  def to_note_score
    
  end
end

end
end
