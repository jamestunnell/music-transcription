module Musicality
# Produces notes that rise or fall.
#
# @author James Tunnell
class IntervalVectorArpeggiator
  attr_reader :interval_vector
  
  def initialize interval_vector
    test_base_pitch = Pitch.new()
    if interval_vector.to_pitches(test_base_pitch).last <= test_base_pitch
      raise ArgumentError, "interval vector #{interval_vector} does not increase overall"
    end
    
    @interval_vector = interval_vector
  end
  
  def rising_arpeggio_over_range pitch_range, rhythm
    raise ArgumentError, "pitch_range must be increasing" unless pitch_range.increasing?
    
    notes = []
    pitch = pitch_range.left
    pitches = []
    
    i = 0
    if pitch_range.exclude_left?
      pitch = next_pitch pitch, pitches, @interval_vector
    end
    
    while pitch < pitch_range.right
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch
      
      pitch = next_pitch pitch, pitches, @interval_vector
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
    pitches = []
    inverse_iv = @interval_vector.inverse
    
    i = 0
    if pitch_range.exclude_left?
      pitch = next_pitch pitch, pitches, inverse_iv
    end
    
    while pitch > pitch_range.right
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch
      
      pitch = next_pitch pitch, pitches, inverse_iv
      i += 1
    end
    
    if pitch_range.include_right?
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch_range.right
    end
    return notes
  end
  
  private
  
  def next_pitch cur_pitch, pitches_left, interval_vector
    if pitches_left.empty?
      pitches_left.concat interval_vector.to_pitches(cur_pitch)
    end
    pitches_left.shift
  end
  
  def make_note duration, pitch
    if duration > 0
      return note(duration, [interval(pitch)])
    elsif duration < 0
      return note(-duration)
    else
      raise ArgumentError, "duration should not be 0"
    end
  end
end

end