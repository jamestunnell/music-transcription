module Music
module Transcription
module Parsing
  DURATION_PARSER = DurationParser.new
  PITCH_PARSER = PitchParser.new
  NOTE_PARSER = NoteParser.new
  METER_PARSER = MeterParser.new
  
  def duration dur_str
    DURATION_PARSER.parse(dur_str).to_r
  end
  alias :dur :duration
  module_function :duration
  module_function :dur
  
  def durations durs_str
    durs_str.split.map do |dur_str|
      duration(dur_str)
    end
  end
  alias :durs :durations
  module_function :durs
  module_function :durations
  
  def pitch p_str
    PITCH_PARSER.parse(p_str).to_pitch
  end
  module_function :pitch

  def pitches ps_str
    ps_str.split.map do |p_str|
      pitch(p_str)
    end
  end
  module_function :pitches
  
  def note note_str
    NOTE_PARSER.parse(note_str).to_note
  end
  module_function :note
  
  def notes notes_str
    notes_str.split.map do |note_str|
      note(note_str)
    end
  end
  module_function :notes
  
  def meter meter_str
    METER_PARSER.parse(meter_str).to_meter
  end
  module_function :meter
end
end
end

class String
  def to_duration
    Music::Transcription::Parsing::duration(self)
  end
  alias :to_dur :to_duration
  alias :to_d :to_duration
  
  def to_durations
    Music::Transcription::Parsing::durations(self)
  end
  alias :to_durs :to_durations
  alias :to_ds :to_durations
  
  def to_pitch
    Music::Transcription::Parsing::pitch(self)
  end
  alias :to_p :to_pitch
  
  def to_pitches
    Music::Transcription::Parsing::pitches(self)
  end
  alias :to_ps :to_pitches
  
  def to_note
    Music::Transcription::Parsing::note(self)
  end
  alias :to_n :to_note
  
  def to_notes
    Music::Transcription::Parsing::notes(self)
  end
  alias :to_ns :to_notes
  
  def to_meter
    Music::Transcription::Parsing::meter(self)
  end
end