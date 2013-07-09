module Musicality
# Produces notes that rise or fall.
#
# @author James Tunnell
class PitchClassArpeggiator
  
  attr_reader :pitch_class_set
  def initialize pitch_class_set
    raise ArgumentError, "pitch_class_set is empty" if pitch_class_set.empty?
    @pitch_class_set = pitch_class_set
    @pcs = pitch_class_set.sort
  end
  
  def rising_arpeggio_over_range pitch_range, rhythm
    if pitch_range.last <= pitch_range.first
      raise ArgumentError, "pitch_range.last must be > pitch_range.first"
    end
    notes = []
    pitch = pitch_range.first
    
    i = 0
    while pitch < pitch_range.last
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch
      pitch = make_next_pitch_up(pitch)
      i += 1
    end
    
    unless pitch_range.exclude_end?
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch_range.last
    end
    return notes
  end

  def falling_arpeggio_over_range pitch_range, rhythm
    if pitch_range.last >= pitch_range.first
      raise ArgumentError, "pitch_range.last must be < pitch_range.first"
    end
    notes = []
    pitch = pitch_range.first
    
    i = 0
    while pitch > pitch_range.last
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch
      pitch = make_next_pitch_down(pitch)
      i += 1
    end
    
    unless pitch_range.exclude_end?
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch_range.last
    end
    return notes
  end
  
  private
  
  def make_note duration, pitch
    if duration > 0
      return note(duration, [interval(pitch)])
    elsif duration < 0
      return note(-duration)
    else
      raise ArgumentError, "duration should not be 0"
    end
  end
  
  def make_next_pitch_up current_pitch
    current_pitch = current_pitch.round
    cur_pc = current_pitch.semitone
    next_pc = find_next_higher_pc(cur_pc)

    octave = current_pitch.octave
    if next_pc <= cur_pc
      octave += 1
    end
    return Pitch.new(:octave => octave, :semitone => next_pc)
  end

  def make_next_pitch_down current_pitch
    current_pitch = current_pitch.round
    cur_pc = current_pitch.semitone
    next_pc = find_next_lower_pc(cur_pc)

    octave = current_pitch.octave
    if next_pc >= cur_pc
      octave -= 1
    end
    return Pitch.new(:octave => octave, :semitone => next_pc)
  end
  
  def find_next_higher_pc cur_pc
    greater_than_cur = @pcs.select {|pc| pc > cur_pc }
    if greater_than_cur.any?
      return greater_than_cur.first
    else
      less_or_equal = @pcs.select {|pc| pc <= cur_pc }
      return less_or_equal.first
    end
  end

  def find_next_lower_pc cur_pc
    less_than_cur = @pcs.select {|pc| pc < cur_pc }
    if less_than_cur.any?
      return less_than_cur.last
    else
      greater_or_equal = @pcs.select {|pc| pc >= cur_pc }
      return greater_or_equal.last
    end
  end
end

end