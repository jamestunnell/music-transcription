module Musicality

# builds notes in bulk from pitches and a rhythm 
class NoteMaker
  def self.make_rest duration
    note(duration)
  end

  def self.monophonic_note duration, pitch
    if duration > 0
      return note duration, [interval(pitch)]
    else
      return note(-duration)
    end
  end

  def self.polyphonic_note duration, pitches
    if duration > 0
      return note duration, pitches.map {|pitch| interval(pitch) }
    else
      return note(-duration)
    end
  end

  def self.monophonic_notes rhythm, pitches
    notes = []
    i = 0

    pitches.each do |pitch|
      duration = rhythm[i % rhythm.count]
      notes.push monophonic_note(duration, pitch)
      i += 1
    end
    
    return notes
  end

  def self.polyphonic_notes rhythm, pitch_groups
    notes = []
    i = 0

    pitch_groups.each do |pitches|
      duration = rhythm[i % rhythm.count]
      notes.push polyphonic_note(duration, pitches)
      i += 1
    end
    
    return notes
  end
end

end