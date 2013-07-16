module Musicality
# Produces notes that rise or fall.
#
# @author James Tunnell
class PitchClassArpeggiator
  
  attr_reader :pitch_classes
  def initialize pitch_classes
    raise ArgumentError, "pitch_classes is empty" if pitch_classes.empty?
    @pitch_classes = pitch_classes
  end
  
  # Arpeggiate forward through pitch_classes, maintaining the given
  # octave.
  def arpeggiate_forward rhythm, octave
    notes = []
    i = 0
    @pitch_classes.each do |pc|
      duration = rhythm[i % rhythm.count]
      pitch = Pitch.new(:semitone => pc, :octave => octave)
      notes.push NoteMaker.monophonic_note(duration, pitch)
      i += 1
    end
    return notes
  end

  # Arpeggiate backward through pitch_classes, maintaining the given 
  # octave.
  def arpeggiate_backward rhythm, octave
    notes = []
    i = 0
    @pitch_classes.reverse_each do |pc|
      duration = rhythm[i % rhythm.count]
      pitch = Pitch.new(:semitone => pc, :octave => octave)
      notes.push NoteMaker.monophonic_note(duration, pitch)
      i += 1
    end
    return notes
  end
end

end