module Musicality

# The performer reads a part, and determines when to start and stop each note. 
# An instrument is used to render note samples. The exact instrument class is 
# specified by the part.
# 
# @author James Tunnell
# 
class Performer

  attr_reader :part, :instrument, :sequencers

  # A new instance of Performer.
  # @param [Part] part The part to be used during performance.
  # @param [Numeric] sample_rate The sample rate used in rendering samples.
  # @param [Class] instrument_class The class to use for an instrument.
  def initialize part, sample_rate
    @sample_rate = sample_rate
    @part = part

    @loudness_computer = ValueComputer.new @part.loudness_profile

    @instruments = []
    part.instrument_plugins.each do |instrument_plugin|
      settings = { :sample_rate => @sample_rate }.merge instrument_plugin.settings
      
      # TODO make an instrument from each plugin config and add to @instruments
    end

    @effects = []
    part.effect_plugins.each do |effect_plugin|
      settings = { :sample_rate => @sample_rate }.merge effect_plugin.settings
      
      # TODO make an effect from each plugin config and add to @effects
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
        event.note.pitches.each do |pitch|
          @instruments.each do |instrument|
            instrument.start_pitch pitch
          end
        end
      end

      event_updates[:to_end].each do |event|
#        puts "ending pitch #{event.note.pitch}"
        event.note.pitches.each do |pitch|
          @instruments.each do |instrument|
            instrument.end_pitch pitch
          end
        end
      end
    end

    loudness = @loudness_computer.value_at counter
    raise ArgumentError, "loudness is not between 0.0 and 1.0" if !loudness.between?(0.0,1.0)
    
    sample = 0.0
    
    @instruments.each do |instrument|
      sample += instrument.render_sample loudness
    end
    
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

