module Musicality

# Implement the logic required for an instrument, that can be used to render notes.
# Can be used to make custom instruments through inheritence. Implements the
# interface expected by Performer.
#
# @author James Tunnell
class Instrument
  
  attr_reader :sample_rate, :envelope_plugin, :voice_plugin, :notes
  
  # A new instance of Instrument.
  #
  # @param [Numeric] sample_rate
  # @param [PluginConfig] voice_plugin Used to make voice objects that will render musical sounds.
  # @param [PluginConfig] envelope_plugin Used to make envelope objects that will control overall amplitude.
  def initialize sample_rate, voice_plugin, envelope_plugin
    @sample_rate = sample_rate

    @envelope_plugin = envelope_plugin
    raise ArgumentError, "PLUGINS does not have plugin #{@envelope_plugin.plugin_name}" unless PLUGINS.plugins.has_key?(@envelope_plugin.plugin_name.to_sym)
    @envelope_plugin.settings[:sample_rate] = @sample_rate

    @voice_plugin = voice_plugin
    @voice_plugin.settings[:sample_rate] = @sample_rate
    raise ArgumentError, "PLUGINS does not have plugin #{@voice_plugin.plugin_name}" unless PLUGINS.plugins.has_key?(@voice_plugin.plugin_name.to_sym)

    @notes = {}
  end
  
  # Start a new note.
  #
  # @param [Note] note The Note to be started. Uses note attack, sustain, and pitches to get started.
  # @param [Symbol] id Identifies the note to be added.
  # @return [Symbol] The Symbol use to identify the note which was just started. Required for other note_ methods.
  def note_on note, id = UniqueToken.make_unique_sym(3)
    envelope_plugin = PLUGINS.plugins[@envelope_plugin.plugin_name.to_sym]
    voice_plugin = PLUGINS.plugins[@voice_plugin.plugin_name.to_sym]
    
    envelope = envelope_plugin.make_envelope @envelope_plugin.settings
    envelope.attack note.attack, note.sustain 
    
    voices = []
    note.pitches.each do |pitch|
      voices << voice_plugin.make_voice(@voice_plugin.settings)
      voices.last.freq = pitch.freq
    end
    
    @notes[id] = { :voices => voices, :envelope => envelope, :envelope_sample => 0.0 }
    return id
  end
  
  # Change the pitches being played for the given note ID. Can be more or less than the number of
  # pitches currently being played.
  # @param [Symbol] id Identifies the note whose pitches are to be modified.
  # @param [Array] pitches The Pitch objects to use.
  def note_change_pitches id, pitches
    voices = @notes[id][:voices]
    
    while voices.count > pitches.count
      voices.pop
    end
    
    while voices.count < pitches.count
      voice_plugin = PLUGINS.plugins[@voice_plugin.plugin_name.to_sym]
      voices.push voice_plugin.make_voice(@voice_plugin.settings)
    end
    
    pitches.each_index do |i|
      voices[i].freq = pitches[i].freq
    end
  end

  # Restart the note attack for the given note ID. Attack and sustain can be different than current.
  # @param [Symbol] id Identifies the note whose attack is to be restarted.
  # @param [Numeric] attack The attack amount (0.0 to 1.0) to use in new attack.
  # @param [Numeric] sustain The sustain amount (0.0 to 1.0) to use in new attack.
  # @raise [ArgumentError] if attack is not between 0.0 and 1.0.
  # @raise [ArgumentError] if sustain is not between 0.0 and 1.0.
  def note_restart_attack id, attack, sustain
    raise ArgumentError, "attack is not between 0.0 and 1.0" unless attack.between?(0.0,1.0)
    raise ArgumentError, "sustain is not between 0.0 and 1.0" unless sustain.between?(0.0,1.0)
    envelope_sample = @notes[id][:envelope_sample]
    @notes[id][:envelope].attack attack, sustain, envelope_sample
  end

  # Release the note identified by the given ID. This will start damping note output.
  # @param [Symbol] id Identifies the note to be released.
  # @param [Numeric] damping The damping amount (0.0 to 1.0) to use.
  # @raise [ArgumentError] if damping is not between 0.0 and 1.0.
  def note_release id, damping
    raise ArgumentError, "damping is not between 0.0 and 1.0" unless damping.between?(0.0,1.0)
    @notes[id][:envelope].release damping
  end
  
  # Remove the note identified by the given ID, so it will not be played.
  # @param [Symbol] id Identifies the note to be removed.
  def note_off id
    @notes.delete id
  end
  
  # Renders a sample which sums the samples for each note being played.
  def render_sample
    output = 0.0
    
    @notes.each do |id, note|
      voices_sample = 0.0
      note[:voices].each do |voice|
        voices_sample += voice.render_sample
      end
      
      envelope_sample = note[:envelope].render_sample
      note[:envelope_sample] = envelope_sample
      
      output += (voices_sample * envelope_sample)
    end
    
    return output
  end
end

end
