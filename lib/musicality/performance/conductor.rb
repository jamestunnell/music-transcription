require 'spcore'

module Musicality

# The conductor reads a score, assigns score parts to performers, prepares the 
# performers to perform, and follows the score tempo as it directs the rendering
# of performance samples.
# 
# @author James Tunnell
# 
class Conductor

  # A plugin config object to load default instrument.
  DEFAULT_INSTRUMENT_PLUGIN = PluginConfig.new(
    :plugin_name => 'synth_instr_3',
    :settings => {
      "harmonic_1_partial" => 0,
      "harmonic_1_wave_type" => SPCore::Oscillator::WAVE_SAWTOOTH,
      "harmonic_1_amplitude" => 0.2,
      "harmonic_2_partial" => 3,
      "harmonic_2_wave_type" => SPCore::Oscillator::WAVE_SQUARE,
      "harmonic_2_amplitude" => 0.10,
      "harmonic_3_partial" => 5,
      "harmonic_3_wave_type" => SPCore::Oscillator::WAVE_SQUARE,
      "harmonic_3_amplitude" => 0.05,
      #:attack_rate_min => SettingProfile.new( :start_value => 150.0 ),
      #:attack_rate_max => SettingProfile.new( :start_value => 250.0 ),
      #:decay_rate_min => SettingProfile.new( :start_value => 25.0 ),
      #:decay_rate_max => SettingProfile.new( :start_value => 50.0 ),
      #:sustain_level_min => SettingProfile.new( :start_value => 0.2 ),
      #:sustain_level_max => SettingProfile.new( :start_value => 0.6 ),
      #:damping_rate_min => SettingProfile.new( :start_value => 100.0 ),
      #:damping_rate_max => SettingProfile.new( :start_value => 200.0 ),
      #
      #:wave_type => SettingProfile.new( :start_value => 'square' )
    }
  )

  attr_reader :sample_rate, :start_of_score, :end_of_score,
               :performers, :time_counter, :sample_counter
  
  # A new instance of Conductor.
  # @param [Score] score The score is used to prepare a performance.
  # @param [Numeric] time_conversion_sample_rate The sample rate used in
  #                                              converting the score from
  #                                              a note base to a time base.
  # @param [Numeric] rendering_sample_rate The sample rate used in rendering
  #                                        samples.
  # @param [Hash] optional_args Hashed args that are not required. Valid keys
  #                             are :max_attack_time, :default_instrument_config,
  #                             and :plugin_dirs.
  def initialize score, time_conversion_sample_rate, rendering_sample_rate, optional_args = {} #arrangement, sample_rate = DEFAULT_SAMPLE_RATE, max_attack_time = 0.15
    raise ArgumentError, "score is not a Score" unless score.is_a?(Score)
    raise ArgumentError, "score contains no parts" if score.parts.empty?
    raise ArgumentError, "time_conversion_sample_rate is not a Numeric" unless time_conversion_sample_rate.is_a?(Numeric)
    raise ArgumentError, "time_conversion_sample_rate is less than 100.0" if time_conversion_sample_rate < 100.0

    ScoreCollator.collate_score!(score)
    parts = ScoreConverter.make_time_based_parts_from_score score, time_conversion_sample_rate
    
    @start_of_score = parts.values.inject(parts.values.first.start_offset) {|so_far, part| now = part.start_offset; (now < so_far) ? now : so_far }
    @end_of_score = parts.values.inject(parts.values.first.end_offset) {|so_far, part| now = part.end_offset; (now > so_far) ? now : so_far }
    
    opts = {
      :max_attack_time => 0.15,
      :plugin_dirs => [], # File.expand_path(File.dirname(__FILE__))
      :default_instrument_config => DEFAULT_INSTRUMENT_PLUGIN,
    }.merge optional_args
    
    max_attack_time = opts[:max_attack_time]
    plugin_dirs = opts[:plugin_dirs]
    instrument_map = InstrumentFinder.find_instruments score, plugin_dirs, opts[:default_instrument_config]

    raise ArgumentError, "rendering_sample_rate is not a Numeric" unless rendering_sample_rate.is_a?(Numeric)
    raise ArgumentError, "rendering_sample_rate is less than 100.0" if rendering_sample_rate < 100.0
    @sample_rate = rendering_sample_rate
    @sample_period = 1.0 / @sample_rate
    
    @performers = []
    parts.each do |id, part|
      raise ArgumentError, "instrument_map does not have key for id #{id}" unless instrument_map.has_key?(id)
      instrument_config = instrument_map[id]
      
      plugin = PLUGINS.plugins[instrument_config.plugin_name.to_sym]
      instrument = plugin.make_instrument(:sample_rate => @sample_rate)
      
      instrument_config.settings.each do |name, val|
        if instrument.params.include? name
          instrument.params[name].set_value val
        end
      end
      
      @performers << Performer.new(part, instrument, max_attack_time)
    end
    
    @time_counter = 0.0
    @sample_counter = 0
  end
  
  # Perform the entire score, producing however many samples as is necessary to
  # render the entire program length.
  def perform start_time = @start_of_score, lead_out_time = 0.0
    prepare_performance_at start_time
    samples = []

    while @time_counter < (@end_of_score + lead_out_time) do
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
  def perform_samples n_samples, start_time = @start_of_score
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
  def perform_seconds t_seconds, start_time = @start_of_score
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

    if @time_counter <= @end_of_score
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

