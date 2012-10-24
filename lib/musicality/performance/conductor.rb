module Musicality

class Conductor

  DEFAULT_SAMPLE_RATE = 48000.0
  
  attr_reader :score, :sample_rate, :end_of_score,
               :tempo_computer, :note_time_converter, :performers,
               :time_counter, :sample_counter, :note_counter
  
  def initialize score, sample_rate = DEFAULT_SAMPLE_RATE
    @score = score
    @tempo_computer = TempoComputer.new( Event.hash_events_by_offset @score.tempos )
    @note_time_converter = NoteTimeConverter.new @tempo_computer, sample_rate
    
    @end_of_score = @score.find_end
    
    @performers = []
    @score.parts.each do |part|
      @performers << Performer.new(part, sample_rate, @note_time_converter)
    end
    
    @sample_rate = sample_rate
    @sample_period = 1 / sample_rate
    
    @time_counter = 0.0
    @sample_counter = 0
    @note_counter = 0.0
  end
  
  def prepare_to_perform note_offset = 0.0
    @time_counter = @note_time_converter.time_elapsed 0, note_offset
    @sample_counter = (@time_counter / @sample_rate).to_i
    @note_counter = note_offset
    
    @performers.each do |performer|
      performer.prepare_to_perform note_offset
    end
  end
  
  def perform_sample
    
    #raise "rendering past end of score!" if @note_counter > @end_of_score
    
    sample = 0.0
    @performers.each do |performer|
      sample += performer.perform_sample(@note_counter, @time_counter)
    end
  
    notes_per_second = @tempo_computer.notes_per_second_at(@note_counter)
    notes_per_sample = notes_per_second * @sample_period
    
    @note_counter += notes_per_sample
    @time_counter += @sample_period
    @sample_counter += 1
    
    return sample
  end
end

end

