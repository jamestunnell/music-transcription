require 'musicality'
require 'pry'
require 'yaml'

include Musicality

#def arpeggiate pitch_range, pitch_class_set, pitch_range, pitch_class_pattern, arpeggio_rhythm
#  raise ArgumentError, "#{pitch_range.left} is not in pitch class set #{pitch_class_set}"
#  raise ArgumentError, "#{pitch_range.right} is not in pitch class set #{pitch_class_set}"
#  
#  arpeggios = []
#  
#  i = 0
#  if pitch_range.include_left?
#    
#  end
#  
#  pitches[0...-1].each do |pitch|
#    left = pitch
#    right_semitone = pcs.next_pitch_class(pcs.next_pitch_class(left.semitone))
#    if right_semitone < left.semitone
#      right_octave = left.octave + 1
#    else
#      right_octave = left.octave
#    end
#    right = Pitch.new(:octave => right_octave, :semitone => right_semitone)
#    range = PitchRange::Closed.new(left,right)
#    
#    a = arpeggiator.rising_arpeggio_over_range(range, arpeggio_rhythm)
#    arpeggios += a
#  end
#  
#  return arpeggios
#end

#arpeggios.push note(Rational(1,4), [interval(pitches.last)])

def make_notes_from_pitches_and_rhythm pitches, rhythm
  notes = []
  i = 0
  pitches.each do |pitch|
    duration = rhythm[i % rhythm.count]
    intervals = []
    if duration > 0
      intervals.push interval(pitch)
    end
    notes.push note(duration, intervals)
    i += 1
  end
  
  return notes
end

notes = []
octave = 3

[ MajorScale.new(C),
  MajorScale.new(D),
  Scale.new(E, NATURAL_MINOR),
  Scale.new(E, HARMONIC_MINOR),
  Scale.new(E, MELODIC_MINOR)
].each do |scale|
  #scale_indices = [0,2,4,2,7,4,2,4]
  scale_indices = (0...7).to_a + (1..7).to_a.reverse
  
  pitches = scale_indices.map { |scale_idx| scale.pitch_at(scale_idx, octave) }
  notes += make_notes_from_pitches_and_rhythm(pitches, [Rational(1,8)])
  notes.push note(Rational(1,2), [interval(pitches.first)])
end

arrangement = Arrangement.new(
  :score => TempoScore.new(
    :tempo_profile => profile(tempo(120)),
    :program => program([0...3]),
    :parts => {
      1 => Part.new(
        :notes => notes
      )
    }
  )
)

File.open('arpeggios_demo.yml', 'w') do |file|
  file.write arrangement.to_yaml
end
