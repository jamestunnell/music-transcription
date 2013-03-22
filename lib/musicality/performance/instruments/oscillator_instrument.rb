require 'musicality'

module Musicality

# A simple instrument to use for rendering. Can select different
# ADSR envelope and oscillator voice settings.
class OscillatorInstrument < Musicality::Instrument
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ a > 0 }),
    :settings => arg_spec_hash(:reqd => false, :type => SettingProfile)
  }
  def initialize args
    hash_make OscillatorInstrument::ARG_SPECS, args

    envelope_plugin = PluginConfig.new(
      :plugin_name => "adsr_envelope",
      :settings => @settings
    )
    voice_plugin = PluginConfig.new(
      :plugin_name => "oscillator_voice",
      :settings => @settings
    )
    
    super( @sample_rate, voice_plugin, envelope_plugin)
  end
end


PLUGINS.register :oscillator_instrument do
  self.author = "James Tunnell"
  self.version = "1.0.0"
  self.extends = [:instrument]
  #self.requires = [ :oscillator_voice, :flat_envelope ]
  self.extension_points = []
  self.params = { :description => "Makes an oscillator-based instrument, with adjustable attack rate, decay rate, sustain level, and damping rate." }

  def make_instrument args
    OscillatorInstrument.new args
  end
end

end