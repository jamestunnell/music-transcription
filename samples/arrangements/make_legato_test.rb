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
        :notes => [
          note(0.25, [ interval(C3) ]),
          note(0.25, [ interval(D3) ]),
          note(0.25, [ interval(E3) ]),
          note(0.25, [ interval(F3) ]),
          note(0.25, [ interval(E3) ]),
          note(0.25, [ interval(D3) ]),
          note(0.5, [ interval(C3) ]),
          note(0.25, [ interval(C3, legato(D3)) ]),
          note(0.25, [ interval(D3, legato(E3)) ]),
          note(0.25, [ interval(E3, legato(F3)) ]),
          note(0.25, [ interval(F3, legato(E3)) ]),
          note(0.25, [ interval(E3, legato(D3)) ]),
          note(0.25, [ interval(D3, legato(C3)) ]),
          note(0.5, [ interval(C3) ]),
        ]
      )
    }
  )
)

File.open("legato_test.yml", "w") do |file|
  file.write arrangement.to_yaml
end
