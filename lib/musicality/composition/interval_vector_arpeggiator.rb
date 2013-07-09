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
    if pitch_range.last <= pitch_range.first
      raise ArgumentError, "pitch_range.last must be > pitch_range.first"
    end
    notes = []
    pitch = pitch_range.first
    pitches = []
    
    i = 0
    while pitch < pitch_range.last
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch
      
      if pitches.empty?
        pitches += @interval_vector.to_pitches(pitch)
      end
      pitch = pitches.shift
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
    pitches = []
    inverse_iv = @interval_vector.inverse
    
    i = 0
    while pitch > pitch_range.last
      duration = rhythm[i % rhythm.count]
      notes.push make_note duration, pitch
      
      if pitches.empty?
        pitches += inverse_iv.to_pitches(pitch)
      end
      pitch = pitches.shift
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
end

end