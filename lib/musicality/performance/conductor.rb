module Musicality

# The conductor reads a score, assigns score parts to performers, prepares the 
# performers to perform, and follows the score tempo as it directs the rendering
# of performance samples.
# 
# @author James Tunnell
# 
class Conductor

  # use this to set sample rate if none is given in construction.
  DEFAULT_SAMPLE_RATE = 48000.0
  
  attr_reader :score, :sample_rate, :end_of_score,
               :tempo_computer, :note_time_converter, :performers, :jumps_left,
               :note_total, :time_total, :sample_total, :note_current
  
  # A new instance of Conductor.
  # @param [Score] score The score to be used during performance.
  # @param [Numeric] sample_rate The sample rate used in rendering samples.
  def initialize score, sample_rate = DEFAULT_SAMPLE_RATE
    raise ArgumentError, "score is invalid" if !score.valid?
    
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
    
    @jumps_left = []
    
    @note_total = 0.0
    @time_total = 0.0
    @sample_total = 0
    @note_current = 0.0
  end
  
  # Give the conductor a chance to set up counters, and for performers to figure
  # which notes will be played. Must be called before any calls to 
  # perform_sample.
  def prepare_performance_at start_offset = @score.program.start
    raise ArgumentError, "start offset is not in score program" if !@score.program.include?(start_offset)
    @jumps_left = @score.program.prepare_jumps_at start_offset

    @note_total = 0.0
    @time_total = 0.0 #@note_time_converter.time_elapsed 0, start_offset
    @sample_total = 0 #(@time_total / @sample_rate).to_i
    @note_current = start_offset
    
    @performers.each do |performer|
      performer.prepare_performance_at start_offset
    end
  end

  # Render an audio sample of the performance at the current note counter.
  # Increments the note counter by the current notes per sample (computed from 
  # current tempo). Increments the sample counter by 1 and the time counter by 
  # the sample period.
  def perform_sample
    
    #raise "rendering past end of score!" if @note_current > @end_of_score
    
    sample = 0.0
    @performers.each do |performer|
      sample += performer.perform_sample(@note_current, @time_total)
    end
  
    notes_per_second = @tempo_computer.notes_per_second_at(@note_current)
    notes_per_sample = notes_per_second * @sample_period
    
    @note_total += notes_per_sample
    @time_total += @sample_period
    @sample_total += 1

    @note_current += notes_per_sample
    if @jumps_left.any? && @note_current >= @jumps_left.first[:at]
      continue_performance_at @jumps_left.first[:to]
      @jumps_left.delete_at(0)
    end
    
    return sample
  end

  private
  
  # Called when a jump occurs. Gives performers a chance to figure which notes 
  # will be played. Preserves total counters and resets current note counter.
  def continue_performance_at offset
    @note_current = offset
    
    @performers.each do |performer|
      performer.prepare_performance_at offset
    end
  end

end

end

