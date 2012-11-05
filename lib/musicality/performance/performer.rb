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
  # @param [NoteTimeConverter] note_time_converter Not currently used. Could be 
  #                                                used for determining note lead
  #                                                time for instruments that have
  #                                                longer attack rise times.
  def initialize part, sample_rate, note_time_converter
    @sample_rate = sample_rate
    @part = part

    settings = { :sample_rate => @sample_rate }.merge @part.instrument.settings
    @instrument = ClassFinder.find_by_name(@part.instrument.class_name).new(settings)
    
    @sequencers = []
    @part.sequences.each do |sequence|
      @sequencers << Sequencer.new(sequence)
    end
  end

  # Figure which notes will be played, starting at the given note offset. Must 
  # be called before any calls to perform_sample.
  #
  # @param [Numeric] note_offset The note offset to begin playing notes at.
  def prepare_performance_at note_offset = 0.0
    @sequencers.each do |sequencer| 
      sequencer.prepare_to_perform note_offset
    end
  end
  
  # Render an audio sample of the part at the current note counter.
  # Start or end notes as needed.
  def perform_sample note_counter, time_counter
    @sequencers.each do |sequencer|
      event_updates = sequencer.update_notes note_counter
      
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

    #now actually render a sample
    return @instrument.render_sample
  end
end

end

