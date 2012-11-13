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
  def initialize part, sample_rate
    @sample_rate = sample_rate
    @part = part

    @dynamic_computer = DynamicComputer.new @part.start_dynamic, @part.dynamic_changes

    settings = { :sample_rate => @sample_rate }.merge @part.instrument.settings
    @instrument = ClassFinder.find_by_name(@part.instrument.class_name).new(settings)
    
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
          @instrument.start_pitch pitch
        end
      end

      event_updates[:to_end].each do |event|
#        puts "ending pitch #{event.note.pitch}"
        event.note.pitches.each do |pitch|
          @instrument.end_pitch pitch
        end
      end
    end

    loudness = @dynamic_computer.loudness_at counter
    raise ArgumentError, "loudness is not between 0.0 and 1.0" if !loudness.between?(0.0,1.0)

    #now actually render a sample
    return @instrument.render_sample loudness
  end

  # Release any currently playing notes
  def release_all
    @instrument.release_all
  end
end

end

