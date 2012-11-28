require 'set'

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
  
  attr_reader :score, :sample_rate, :start_of_score, :end_of_score,
               :performers, :time_counter, :sample_counter
  
  # A new instance of Conductor.
  # @param [Arrangement] arrangement The arrangement to be used during performance.
  # @param [Numeric] sample_rate The sample rate used in rendering samples.
  def initialize arrangement, sample_rate = DEFAULT_SAMPLE_RATE
    raise ArgumentError, "arrangement is not an Arrangement" unless arrangement.is_a?(Arrangement)
    @arrangement = arrangement
    
    @performers = []
    @arrangement.parts.each do |part|
      @performers << Performer.new(part, sample_rate)#, @arrangement.instrument_map, @arrangement.effect_map)
    end
    
    @sample_rate = sample_rate
    @sample_period = 1.0 / sample_rate
    
    @time_counter = 0.0
    @sample_counter = 0
  end
  
  # Perform the entire score, producing however many samples as is necessary to
  # render the entire program length.
  def perform start_time = @arrangement.start, lead_out_time = 0.0
    prepare_performance_at start_time
    samples = []

    while @time_counter < (@arrangement.end + lead_out_time) do
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
  def perform_samples n_samples, start_time = @arrangement.start
    prepare_performance_at start_time
    samples = []
    
    n_samples.times do
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
  def perform_seconds t_seconds, start_time = @arrangement.start
    prepare_performance_at start_time
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

  ## Perform part of the score, producing as many samples as is necessary to 
  ## render n_notes notes of the score. 
  ## @param [Numeric] n_notes The number of notes of the score to render.    
  #def perform_notes
  #  prepare_performance
  #  samples = []
  #
  #  while @note_counter < n_notes
  #    sample = perform_sample
  #
  #    if block_given?
  #      yield sample
  #    else
  #      samples << sample
  #    end
  #  end
  #  
  #  return samples
  #end

  private
  
  # Give the conductor a chance to set up counters, and for performers to figure
  # which notes will be played. Must be called before any calls to 
  # perform_sample.
  def prepare_performance_at start_time = 0.0
    @time_counter = start_time
    @sample_counter = (@time_counter * @sample_period).to_i
    
    @performers.each do |performer|
      performer.prepare_performance_at @time_counter
    end
  end

  # Render an audio sample of the performance at the current note counter.
  # Increments the note counter by the current notes per sample (computed from 
  # current tempo). Increments the sample counter by 1 and the time counter by 
  # the sample period.
  def perform_sample
    sample = 0.0

    if @time_counter <= @arrangement.end
      @performers.each do |performer|
        sample += performer.perform_sample(@time_counter)
      end
    end
    
    @time_counter += @sample_period
    @sample_counter += 1
    
    return sample
  end

end

end

