require 'musicality'

module Musicality

# A simple instrument to use for rendering. Can select different
# ADSR envelope and oscillator voice settings.
class OscillatorInstrument < Musicality::Instrument
  def initialize settings

    envelope_plugin = PluginConfig.new(
      :plugin_name => "adsr_envelope",
      :settings => settings
    )
    voice_plugin = PluginConfig.new(
      :plugin_name => "oscillator_voice",
      :settings => settings
    )
    
    super( settings[:sample_rate], voice_plugin, envelope_plugin)
  end
end


PLUGINS.register :oscillator_instrument do
  self.author = "James Tunnell"
  self.version = "1.0.0"
  self.extends = [:instrument]
  #self.requires = [ :oscillator_voice, :flat_envelope ]
  self.extension_points = []
  self.params = { :description => "Makes an oscillator-based instrument, with adjustable attack rate, decay rate, sustain level, and damping rate." }

  def make_instrument settings
    OscillatorInstrument.new settings
  end
end

end