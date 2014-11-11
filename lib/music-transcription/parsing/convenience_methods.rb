module Music
module Transcription

  class Duration
    PARSER = Parsing::DurationParser.new
    CONVERSION_METHOD = :to_r
    include Parseable
  end
  
  class Pitch
    PARSER = Parsing::PitchParser.new
    CONVERSION_METHOD = :to_pitch
    include Parseable
  end
  
  class Note
    PARSER = Parsing::NoteParser.new
    CONVERSION_METHOD = :to_note
    include Parseable
  end

  class Meter
    PARSER = Parsing::MeterParser.new
    CONVERSION_METHOD = :to_meter
    include Parseable
  end
  
  class Segment
    PARSER = Parsing::SegmentParser.new
    CONVERSION_METHOD = :to_range
    include Parseable
  end
  
  class Tempo
    PARSER = Parsing::TempoParser.new
    CONVERSION_METHOD = :to_tempo
    include Parseable
  end
end
end

class String
  def to_duration
    Music::Transcription::Duration.parse(self)
  end
  alias :to_dur :to_duration
  alias :to_d :to_duration
  
  def to_durations pattern=" "
    Music::Transcription::Duration.split_parse(self, pattern)
  end
  alias :to_durs :to_durations
  alias :to_ds :to_durations
  
  def to_pitch 
    Music::Transcription::Pitch.parse(self)
  end
  alias :to_p :to_pitch
  
  def to_pitches pattern=" "
    Music::Transcription::Pitch.split_parse(self, pattern)
  end
  alias :to_ps :to_pitches
  
  def to_note
    Music::Transcription::Note.parse(self)
  end
  alias :to_n :to_note
  
  def to_notes pattern=" "
    Music::Transcription::Note.split_parse(self, pattern)
  end
  alias :to_ns :to_notes
  
  def to_meter
    Music::Transcription::Meter.parse(self)
  end
  
  def to_segment
    Music::Transcription::Segment.parse(self)
  end
end