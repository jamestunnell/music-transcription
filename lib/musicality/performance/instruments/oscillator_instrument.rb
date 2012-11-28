require 'musicality'

module Musicality
class OscillatorInstrument < Musicality::Instrument
  def initialize settings

    envelope_plugin = PluginConfig.new(
      :plugin_name => "flat_envelope",
      #:plugin_name => "adsr_envelope",
      :settings => {
        #:attack_time => SettingProfile.new(:start_value => 0.01),
        #:decay_time => SettingProfile.new(:start_value => 0.01),
        #:release_time => SettingProfile.new(:start_value => 0.01)
      }.merge(settings)
    )
    voice_plugin = PluginConfig.new(
      :plugin_name => "oscillator_voice",
      :settings => {
        :wave_type => SettingProfile.new( :start_value => 'square')
      }.merge(settings)
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
  self.params = { :description => "Makes an oscillator-based instrument, with adjustable attack, decay, and release time." }

  def make_instrument settings
    OscillatorInstrument.new settings
  end
end

end