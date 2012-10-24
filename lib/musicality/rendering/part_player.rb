module Musicality

class VerySimpleInstrument
  
  attr_reader :pitches
  
  def initialize sample_rate
    @sample_rate = sample_rate
    @pitches = {}
  end
  
  def start_pitch pitch
    phase_incr = (pitch.ratio * Math::PI * 2.0) / @sample_rate.to_f
    @pitches[pitch] = { :phase_incr => phase_incr, :phase => 0.0 }
  end
  
  def end_pitch pitch
    @pitches.delete pitch
  end
  
  def render_sample
    sample = 0
    
    @pitches.each do |pitch, state|
      sample += Math::sin state[:phase]
      state[:phase] += state[:phase_incr]
    end
    
    return sample
  end
end

class PartPlayer

  attr_reader :part, :instrument, :notes_not_yet_played, :notes_being_played, :notes_played
  
  def initialize part, sample_rate, note_time_converter
    @part = part
    @note_time_converter = note_time_converter
    
    @instrument = VerySimpleInstrument.new sample_rate
    
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

