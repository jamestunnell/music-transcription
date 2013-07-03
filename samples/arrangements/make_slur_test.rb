require 'musicality'
require 'yaml'

include Musicality

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
          note(0.25, [ interval(C3, slur(D3)) ]),
          note(0.25, [ interval(D3, slur(E3)) ]),
          note(0.25, [ interval(E3, slur(F3)) ]),
          note(0.25, [ interval(F3, slur(E3)) ]),
          note(0.25, [ interval(E3, slur(D3)) ]),
          note(0.25, [ interval(D3, slur(C3)) ]),
          note(0.5, [ interval(C3) ]),
        ]
      )
    }
  )
)

File.open("slur_test.yml", "w") do |file|
  file.write arrangement.to_yaml
end
