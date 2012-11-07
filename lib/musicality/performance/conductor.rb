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
               :tempo_computer, :note_time_converter, :performers, :segments_left,
               :note_counter, :time_counter, :sample_counter, :note_cursor
  
  # A new instance of Conductor.
  # @param [Score] score The score to be used during performance.
  # @param [Numeric] sample_rate The sample rate used in rendering samples.
  def initialize score, sample_rate = DEFAULT_SAMPLE_RATE
    @score = score
    @tempo_computer = TempoComputer.new( @score.start_tempo, @score.tempo_changes )
    @note_time_converter = NoteTimeConverter.new @tempo_computer, sample_rate
    
    @end_of_score = @score.find_end
    
    @performers = []
    @score.parts.each do |part|
      @performers << Performer.new(part, sample_rate, @note_time_converter)
    end
    
    @sample_rate = sample_rate
    @sample_period = 1 / sample_rate
    
    @segment_current = []
    @segments_left = []
    
    @note_cursor = 0.0
    
    @note_counter = 0.0
    @time_counter = 0.0
    @sample_counter = 0.0
  end
  
  # Perform the entire score, producing however many samples as is necessary to
  # render the entire program length.
  def perform_score
    prepare_performance
    samples = []

    while @note_counter < @score.program.length do
      sample = perform_sample

      if block_given?
        yield sample
      else
        samples << sample
      end
    end
    
    return samples
  end

  # Perform part of the score, producing as many samples as is given by n_samples.
  # @param [Numeric] n_samples The number of samples of the score to render.
  def perform_samples n_samples
    prepare_performance
    samples = []
    
    while @sample_counter < n_samples do
      sample = perform_sample

      if block_given?
        yield sample
      else
        samples << sample
      end
    end
    
    return samples
  end

  # Perform part of the score, producing as many samples as is necessary to 
  # render t_seconds seconds of the score. 
  # @param [Numeric] t_seconds The number of seconds of the score to render.  
  def perform_seconds t_seconds
    prepare_performance
    samples = []
    
    while @time_counter < t_seconds do
      sample = perform_sample

      if block_given?
        yield sample
      else
        samples << sample
      end
    end
    
    return samples
  end

  # Perform part of the score, producing as many samples as is necessary to 
  # render n_notes notes of the score. 
  # @param [Numeric] n_notes The number of notes of the score to render.    
  def perform_notes
    prepare_performance
    samples = []

    while @note_counter < n_notes
      sample = perform_sample

      if block_given?
        yield sample
      else
        samples << sample
      end
    end
    
    return samples
  end

  private
  
  # Give the conductor a chance to set up counters, and for performers to figure
  # which notes will be played. Must be called before any calls to 
  # perform_sample.
  def prepare_performance
    @note_counter = 0.0 #@score.program.note_elapsed_at start_offset
    @time_counter = 0.0 #@score.program.time_elapsed_at start_offset, @note_time_converter
    @sample_counter = 0.0 #(@time_counter / @sample_rate)

    @segment_current = nil
    @segments_left = @score.program.segments.clone
    prepare_next_segment
  end

  # Render an audio sample of the performance at the current note counter.
  # Increments the note counter by the current notes per sample (computed from 
  # current tempo). Increments the sample counter by 1 and the time counter by 
  # the sample period.
  def perform_sample
        
    sample = 0.0

    notes_per_second = @tempo_computer.notes_per_second_at(@note_cursor)
    notes_per_sample = notes_per_second * @sample_period
    
    if @segment_current.nil?
      @note_counter += notes_per_sample
      @time_counter += @sample_period
      @sample_counter += 1.0

      @note_cursor += notes_per_sample
    else
      raise "@note_cursor #{@note_cursor} is not included in the current program segment" if !@segment_current.include?(@note_cursor)


      if (notes_per_sample + @note_cursor) >= @segment_current.last
        @performers.each do |performer|
          performer.release_all
        end
      end
          
      @performers.each do |performer|
        sample += performer.perform_sample(@note_cursor, @time_counter)
      end

      if (notes_per_sample + @note_cursor) >= @segment_current.last
        diff = @segment_current.last - @note_cursor
        perc = diff / notes_per_sample
        
        @note_counter += diff
        @time_counter += (@sample_period * perc)
        @sample_counter += perc
        
        prepare_next_segment
      else
        @note_counter += notes_per_sample
        @time_counter += @sample_period
        @sample_counter += 1.0

        @note_cursor += notes_per_sample
      end
    end
    
    return sample
  end

  private
  
  # Prepare the next program segment to be played
  def prepare_next_segment
    if @segments_left.any?

      @segment_current = @segments_left.first
      @segments_left.delete_at(0)

      @note_cursor = @segment_current.first
              
      @performers.each do |performer|
        performer.prepare_performance_at @note_cursor
      end
    else
      @segment_current = nil
    end
  end

end

end

