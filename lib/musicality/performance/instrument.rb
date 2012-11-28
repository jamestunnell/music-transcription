module Musicality

class Instrument
  
  attr_reader :sample_rate, :envelope_plugin, :voice_plugin, :notes
  
  def initialize sample_rate, voice_plugin, envelope_plugin
    @sample_rate = sample_rate
    @voice_plugin = voice_plugin
    @voice_plugin.settings[:sample_rate] = @sample_rate
    @envelope_plugin = envelope_plugin
    @envelope_plugin.settings[:sample_rate] = @sample_rate
    @notes = {}
  end
  
  def note_on freq, attack, sustain
    id = UniqueToken.make_unique_token(3)

    envelope_plugin = PLUGINS.plugins[@envelope_plugin.plugin_name.to_sym]
    voice_plugin = PLUGINS.plugins[@voice_plugin.plugin_name.to_sym]
    
    envelope = envelope_plugin.make_envelope @envelope_plugin.settings
    envelope.restart attack, sustain 

    voice = voice_plugin.make_voice @voice_plugin.settings
    voice.change_freq freq
    
    @notes[id] = { :voice => voice, :envelope => envelope }
    return id
  end
  
  def note_change_freq id, freq
    @notes[id][:voice].change_freq freq
  end

  def note_restart_envelope id, attack, sustain
    @notes[id][:envelope].restart attack, sustain
  end
  
  def note_off id
    @notes.delete id
  end
  
  def render_sample loudness
    output = 0.0
    
    @notes.each do |id, note|
      envelope = note[:envelope].render_sample
      sample = note[:voice].render_sample
      
      output += (sample * envelope)
    end
    
    return loudness * output
  end
end

end
