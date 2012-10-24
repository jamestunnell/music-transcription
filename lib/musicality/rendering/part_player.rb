module Musicality

class PartPlayer

  attr_reader :part, :instrument, :notes_not_yet_played, :notes_being_played, :notes_played
  
  def initialize part, sample_rate, note_time_converter
    @part = part
    @note_time_converter = note_time_converter
    
    @instrument = SquareWave.new sample_rate
    
    @notes_not_yet_played = []
    @notes_being_played = []
    @notes_played = []
  end

  def init_render_at note_offset
    @notes_not_yet_played = @part.notes.keep_if { |note| note.offset >= note_offset }
    @notes_being_played.clear
    @notes_played.clear
  end
  
  def render_sample note_counter, time_counter
    notes_to_start_now = @notes_not_yet_played.select { |note| note.offset <= note_counter }
    @notes_not_yet_played = @notes_not_yet_played.select { |note| note.offset > note_counter }
    
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

