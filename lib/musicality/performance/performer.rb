module Musicality

# The performer reads a part, and determines when to start and stop each note. 
# An instrument is used to render note samples. The exact instrument class is 
# specified by the part.
# 
# @author James Tunnell
# 
class Performer

  attr_reader :part, :instrument, :effects, :sequencers

  # A new instance of Performer.
  # @param [Part] part The part to be used during performance.
  # @param [Numeric] sample_rate The sample rate used in rendering samples.
  def initialize part, sample_rate
    @sample_rate = sample_rate
    @part = part

    @loudness_computer = ValueComputer.new @part.loudness_profile

    settings = { :sample_rate => @sample_rate }.merge @part.instrument_plugin.settings
    plugin = PLUGINS.plugins[@part.instrument_plugin.plugin_name.to_sym]
    @instrument = plugin.make_instrument(settings)

    @effects = []
    part.effect_plugins.each do |effect_plugin|
      settings = { :sample_rate => @sample_rate }.merge effect_plugin.settings
      
      plugin = PLUGINS.plugins[effect_plugin.plugin_name.to_sym]
      @effects << plugin.make_effect(settings)
    end
    
    @sequencers = []
    @part.sequences.each do |sequence|
      @sequencers << Sequencer.new(sequence)
    end
  end

  # Figure which notes will be played, starting at the given offset. Must 
  # be called before any calls to perform_sample.
  #
  # @param [Numeric] offset The offset to begin playing notes at.
  def prepare_performance_at offset = 0.0
    @sequencers.each do |sequencer| 
      sequencer.prepare_to_perform offset
    end
  end
  
  # Render an audio sample of the part at the current offset counter.
  # Start or end notes as needed.
  #
  # @param [Numeric] counter The offset to sample performance at.
  def perform_sample counter
    @sequencers.each do |sequencer|
      event_updates = sequencer.update_notes counter
      
      event_updates[:to_start].each do |event|
#        puts "starting pitch #{event.note.pitch}"
        id = event.id
        attack = event.note.attack
        sustain = event.note.sustain
        
        event.note.pitches.each do |pitch|
          @instrument.note_on id, pitch.freq, attack, sustain
        end
      end

      event_updates[:to_end].each do |event|
#        puts "ending pitch #{event.note.pitch}"
        event.note.pitches.each do |pitch|
          @instrument.note_off event.id
        end
      end
    end

    loudness = @loudness_computer.value_at counter
    raise ArgumentError, "loudness is not between 0.0 and 1.0" if !loudness.between?(0.0,1.0)
    
    sample = @instrument.render_sample loudness
    
    @effects.each do |effect|
      sample += effect.render_sample loudness
    end
    
    return sample
  end

  # Release any currently playing notes
  def release_all
    @instrument.release_all
  end
end

end

