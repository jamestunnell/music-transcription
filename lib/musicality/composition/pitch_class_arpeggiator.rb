module Musicality
# Produces notes that rise or fall.
#
# @author James Tunnell
class PitchClassArpeggiator
  
  attr_reader :pitch_class_set
  def initialize pitch_class_set
    raise ArgumentError, "pitch_class_set is empty" if pitch_class_set.empty?
    @pitch_class_set = pitch_class_set
  end
  
  def rising_arpeggio_over_range pitch_range, rhythm
    raise ArgumentError, "pitch_range must be increasing" unless pitch_range.increasing?
    
    notes = []
    pitch = pitch_range.left
    i = 0
    
    if pitch_range.exclude_left?
      pitch = make_next_pitch_up(pitch)
    end
    
    while pitch < pitch_range.right
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch
      pitch = make_next_pitch_up(pitch)
      i += 1
    end
    
    if pitch_range.include_right?
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch_range.right
    end
    return notes
  end

  def falling_arpeggio_over_range pitch_range, rhythm
    raise ArgumentError, "pitch_range must be decreasing" unless pitch_range.decreasing?
    
    notes = []
    pitch = pitch_range.left
    i = 0
    
    if pitch_range.exclude_left?
      pitch = make_next_pitch_down(pitch)
    end
    
    while pitch > pitch_range.right
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch
      pitch = make_next_pitch_down(pitch)
      i += 1
    end
    
    if pitch_range.include_right?
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch_range.right
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
    next_pc = @pitch_class_set.next_pitch_class(cur_pc)

    octave = current_pitch.octave
    if next_pc <= cur_pc
      octave += 1
    end
    return Pitch.new(:octave => octave, :semitone => next_pc)
  end

  def make_next_pitch_down current_pitch
    current_pitch = current_pitch.round
    cur_pc = current_pitch.semitone
    prev_pc = @pitch_class_set.prev_pitch_class(cur_pc)

    octave = current_pitch.octave
    if prev_pc >= cur_pc
      octave -= 1
    end
    return Pitch.new(:octave => octave, :semitone => prev_pc)
  end
end

end