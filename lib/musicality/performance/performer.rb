module Musicality

# The performer reads a part, and determines when to start and stop each note. 
# An instrument is used to render note samples. The exact instrument class is 
# specified by the part.
# 
# @author James Tunnell
# 
class Performer

  attr_reader :part, :instrument, :notes_to_be_played, :notes_being_played, :notes_played

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
    @instrument = @part.instrument.class.new settings
    
    @notes_to_be_played = []
    @notes_being_played = []
    @notes_played = []
  end

  # Figure which notes will be played. Must be called before any calls to 
  # perform_sample.
  def prepare_to_perform note_offset
    @notes_to_be_played = @part.notes.keep_if { |note| note.offset >= note_offset }
    @notes_being_played.clear
    @notes_played.clear
  end
  
  # Render an audio sample of the part at the current note counter.
  # Start or end notes as needed.
  def perform_sample note_counter, time_counter
    notes_to_start_now = @notes_to_be_played.select { |note| note.offset <= note_counter }
    @notes_to_be_played = @notes_to_be_played.select { |note| note.offset > note_counter }
    
    notes_to_end_now = @notes_being_played.select { |note| (note.offset + note.duration) <= note_counter }
    @notes_being_played = @notes_being_played.select { |note| (note.offset + note.duration) > note_counter }
    
    notes_to_start_now.each do |note|
      @instrument.start_pitch note.pitch
      @notes_being_played << note
    end
    
    notes_to_end_now.each do |note|
      @instrument.end_pitch note.pitch
      @notes_played << note
    end
    
    #now actually render a sample
    return @instrument.render_sample
  end
end

end

