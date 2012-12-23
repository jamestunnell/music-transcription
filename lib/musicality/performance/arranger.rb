module Musicality

# Finds an instrument for each part in a score.
#
# @author James Tunnell
#
# @!attribute [r] default_instrument_config
#   @return [InstrumentConfig] If no config is specific for a part, or if the
#                              config cannot be used, the default config will
#                              be used.
#
class Arranger

  attr_reader :default_instrument_config, :plugin_dirs

  # A new instance of Arranger.
  #
  # @param [Hash] args Hashed arguments. Optional keys are
  #                    :default_instrument_plugin and :plugin_dirs.
  def initialize args = {}
    default_instrument_plugin = PluginConfig.new(
      :plugin_name => 'oscillator_instrument',
      :settings => {
        
        :attack_rate_min => SettingProfile.new( :start_value => 150.0 ),
        :attack_rate_max => SettingProfile.new( :start_value => 250.0 ),
        :decay_rate_min => SettingProfile.new( :start_value => 25.0 ),
        :decay_rate_max => SettingProfile.new( :start_value => 50.0 ),
        :sustain_level_min => SettingProfile.new( :start_value => 0.2 ),
        :sustain_level_max => SettingProfile.new( :start_value => 0.6 ),
        :damping_rate_min => SettingProfile.new( :start_value => 100.0 ),
        :damping_rate_max => SettingProfile.new( :start_value => 200.0 ),
        
        :wave_type => SettingProfile.new( :start_value => 'square' )
      }
    )

    args = {
      :default_instrument_plugin => default_instrument_plugin,
      :plugin_dirs => [] # File.expand_path(File.dirname(__FILE__))
    }.merge args
    
    @default_instrument_plugin = args[:default_instrument_plugin]
    @plugin_dirs = args[:plugin_dirs]
    
    @plugin_dirs.each do |dir|
      puts "loading plugins from #{dir}"
      PLUGINS.load_plugins dir
    end
    
    unless PLUGINS.plugins.has_key?(@default_instrument_plugin.plugin_name.to_sym)
      raise ArgumentError, "default instrument plugin #{@default_instrument_plugin.plugin_name} is not registered"
    end
  end
  
  # Make an Arrangment from a Score, which includes converting note-based
  # offsets & durations to time-based.
  # @param [Score] score The score to be used to make an Arrangement.
  # @param [Numeric] conversion_sample_rate The sample rate used in converting
  #                                         from note-base to time-base
  def make_arrangement score, conversion_sample_rate = 1000.0
    raise ArgumentError, "score has no parts" unless score.parts.any?
    raise ArgumentError, "conversion_sample_rate is not a Numeric" unless conversion_sample_rate.is_a?(Numeric)
    raise ArgumentError, "conversion_sample_rate is less than 100.0" if conversion_sample_rate < 100.0
    
    ScoreCollator.collate_score!(score)
    parts = ScoreConverter.make_time_based_parts_from_score score, conversion_sample_rate
        
    parts.each do |part|
      
      part.instrument_plugins.keep_if { |plugin| PLUGINS.plugins.has_key? plugin.plugin_name.to_sym }
      
      if part.instrument_plugins.empty?
        part.instrument_plugins << @default_instrument_plugin
      end
      
      part.effect_plugins.keep_if { |plugin| PLUGINS.plugins.has_key? plugin.plugin_name.to_sym }

    end
    
    return Arrangement.new(parts)
  end
  
end
end
