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
    [ :check_start_tempo_type, :check_tempo_change_types ]
  end
  
  def validatables
    [ @program ] + @tempo_changes.values + @parts.values
  end
  
  def valid_tempo_types
    [ Tempo::QNPM, Tempo::NPM, Tempo::NPS ]
  end
  
  def check_start_tempo_type
    unless valid_tempo_types.include?(@start_tempo.class)
      raise TypeError, "type of start tempo #{@start_tempo} is not one of valid tempo types: #{valid_tempo_types}"
    end
  end

  def check_tempo_change_types
    baddtypes = @tempo_changes.select {|k,v| !valid_tempo_types.include?(v.value.class) }
    if baddtypes.any?
      raise NonPositiveError, "type of tempo change values #{baddtypes} are not one of valid tempo types: #{valid_tempo_types}"
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
