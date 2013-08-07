require 'music-transcription'
require 'yaml'

include Music::Transcription

arrangement = Arrangement.new(
  :score => TempoScore.new(
    :program => Program.new(
      :segments => [0...4.0]
    ),
    :tempo_profile => profile(tempo(120)),
    :parts => {
      1 => Part.new(
        :loudness_profile => profile(0.5),
        :notes => [
          note(0.75, [ interval(C3, portamento(F3)) ]),
          note(0.75, [ interval(F3, portamento(C3)) ]),
          note(0.5, [ interval(C3) ]),
        ]
      )
    }
  )
)

File.open("portamento_test.yml", "w") do |file|
  file.write arrangement.to_yaml
end
