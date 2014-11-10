module Music
module Transcription

class NoteScore
  include Validatable
  
  attr_accessor :start_tempo, :parts, :program, :tempo_changes
  
  def initialize start_tempo, tempo_changes: {}, parts: {}, program: Program.new
    @start_tempo = start_tempo
    @tempo_changes = tempo_changes
    @parts = parts
    @program = program
    
    yield(self) if block_given?
  end

  def check_methods
    [ :check_start_tempo, :check_tempo_changes ]
  end
  
  def validatables
    [ @program ] + @tempo_changes.values + @parts.values
  end
    
  def check_start_tempo
    unless @start_tempo > 0
      raise NonPositiveError, "start tempo #{@start_tempo} is not positive"
    end
  end
  
  def check_tempo_changes
    not_positive = @tempo_changes.select {|k,v| v.value <= 0}
    if not_positive.any?
      raise NonPositiveError, "tempo changes #{not_positive} are not positive"
    end
  end
  
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  def ==(other)
    return @start_tempo == other.start_tempo &&
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
