require 'musicality'
require 'pry'
require 'yaml'

include Musicality

notes = []
octave = 3

[ MajorScale.new(C),
  MajorScale.new(D),
  Scale.new(E, NATURAL_MINOR),
  Scale.new(E, HARMONIC_MINOR),
  Scale.new(E, MELODIC_MINOR)
].each do |scale|
  scale_indices = [0,2,4,2,7,4,2,4]
  #scale_indices = (0...7).to_a + (1..7).to_a.reverse
  pitches = scale.pitches_at(scale_indices, octave)
  notes += NoteMaker.monophonic_notes([Rational(1,8)], pitches)
  notes.push NoteMaker.monophonic_note(Rational(1,2), pitches.first)
end


arrangement = Arrangement.new(
  :score => TempoScore.new(
    :tempo_profile => profile(tempo(120)),
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
