module Music
module Transcription

class Score
  include Validatable
  
  attr_reader :start_meter, :start_tempo, :parts, :program, :meter_changes, :tempo_changes
  
  @@check_methods = [ :check_start_tempo, :check_tempo_changes, :check_meter_changes ]
  def initialize start_meter, start_tempo, meter_changes: {}, tempo_changes: {}, parts: {}, program: Program.new
    @start_meter = start_meter
    @start_tempo = start_tempo
    @meter_changes = meter_changes
    @tempo_changes = tempo_changes
    @parts = parts
    @program = program
    
    yield(self) if block_given?
  end
  
  def validatables
    return [ @program, @start_meter ] +
      @tempo_changes.values +
      @meter_changes.values + 
      @meter_changes.values.map {|v| v.value} +
      @parts.values 
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
  
  def check_meter_changes
    nonzero_duration = @meter_changes.select {|k,v| v.duration != 0 }
    if nonzero_duration.any?
      raise NonZeroError, "meter changes #{nonzero_duration} have non-zero duration"
    end
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
