require 'spcore'

module Musicality

# A plugin config object to load default instrument.
DEFAULT_INSTRUMENT_CONFIG = InstrumentConfig.new(
  :plugin_name => "synth_instr_3",
  :initial_settings => {
    "harmonic_1_partial" => 0,
    "harmonic_1_wave_type" => SPCore::Oscillator::WAVE_SAWTOOTH,
    "harmonic_1_amplitude" => 0.2,
    "harmonic_2_partial" => 3,
    "harmonic_2_wave_type" => SPCore::Oscillator::WAVE_SQUARE,
    "harmonic_2_amplitude" => 0.10,
    "harmonic_3_partial" => 5,
    "harmonic_3_wave_type" => SPCore::Oscillator::WAVE_SQUARE,
    "harmonic_3_amplitude" => 0.05,
    "attack_rate" => 150.0,
    "decay_rate" => 25.0,
    "sustain_level" => 0.5,
    "damping_rate" => 100.0
  }
)

# Contains a Score object, and also instrument configurations to be assigned to
# score parts.
class Arrangement
  include Hashmake::HashMakeable
  
  # specifies which hashed args can be used for initialize.
  ARG_SPECS = {
    :score => arg_spec(:reqd => true, :type => Score),
    :instrument_configs => arg_spec_hash(:reqd => false, :type => InstrumentConfig),
  }

  attr_reader :score, :instrument_configs
  
  def initialize args
    hash_make Arrangement::ARG_SPECS, args
  end
  
  # Builds instruments for each part. If no configuration is given for a part,
  # the default configuration is used.
  # @param [Fixnum] sample_rate
  # @param [PluginConfig] default_config
  def make_instruments sample_rate, default_config = DEFAULT_INSTRUMENT_CONFIG
    instrument_map = {}
    
    @instrument_configs.each do |part_id, config|
      instrument_map[part_id] = InstrumentPlugin.make_instrument sample_rate, config
    end
   
    @score.parts.keys.each do |part_id|
      unless instrument_map.has_key?(part_id)
        instrument_map[part_id] = InstrumentPlugin.make_instrument sample_rate, default_config
      end
    end
    
    return instrument_map
  end
end
end
