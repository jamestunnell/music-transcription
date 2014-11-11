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
    unless @start_tempo.is_a? Tempo
      raise TypeError, "start tempo #{@start_tempo} is not a Tempo object"
    end
  end
  
  def check_tempo_changes
    non_tempos = @tempo_changes.select {|k,v| !v.value.is_a?(Tempo) }
    if non_tempos.any?
      raise NonPositiveError, "tempo change values #{non_tempos} are not Tempo objects"
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
