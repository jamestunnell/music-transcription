require 'musicality'
require 'yaml'

include Musicality

arrangement = Arrangement.new(
  :score => TempoScore.new(
    :program => Program.new(
      :segments => [
        0...4.0,
        0...4.0
      ]
    ),
    :tempo_profile => profile(tempo(120)),
    :parts => {
      1 => Part.new(
        :notes => [
          note(0.375, [interval(C2) ]),
          note(0.25, [interval(Eb2) ]),
          note(0.3125, [interval(F2) ]),
          note(0.0625, [interval(Eb2) ]),
          # 1.0
          note(0.125),
          note(0.25, [interval(C2) ]),
          note(0.25, [interval(Eb2) ]),
          note(0.375),
          # 2.0
          note(0.375, [interval(C2) ]),
          note(0.25, [interval(Eb2) ]),
          note(0.3125, [interval(F2) ]),
          note(0.0625, [interval(Eb2) ]),
          # 3.0
          note(0.125),
          note(0.25, [interval(C2) ]),
          note(0.25, [interval(Eb2) ]),
        ]
      ), 
      2 => Part.new(
        :notes => [
          # 0.0
          note(0.125),
          note(0.125, [interval(Bb3) ]),
          note(0.125, [interval(Bb3) ]),
          note(0.125, [interval(Bb3) ]),
          note(0.125, [interval(Bb3) ]),
          note(0.25, [interval(C4) ]),
          note(0.25, [interval(A3) ]),
          note(0.125, [interval(G3) ]),
          note(0.125, [interval(F3) ]),
          note(0.3125, [interval(G3, slur(F3)) ]),
          note(0.0625, [interval(F3, slur(E3)) ]),
          note(0.125, [interval(E3) ]),
          note(0.125),
          # 2.0
          note(0.125),
          note(0.125, [interval(Bb3) ]),
          note(0.125, [interval(Bb3) ]),
          note(0.125, [interval(Bb3) ]),
          note(0.125, [interval(Bb3) ]),
          note(0.25, [interval(C4) ]),
          note(0.125, [interval(A3) ]),
          note(0.125, [interval(E4) ]),
          note(0.125, [interval(E4, slur(D4)) ]),
          note(0.125, [interval(D4, slur(C4)) ]),
          note(0.125, [interval(C4) ]),
        ]
      )
    }
  ),
  :instrument_configs => {
    1 => InstrumentConfig.new(
      :plugin_name => 'synth_instr_3',
      :initial_settings => "blend"
    ),
    2 => InstrumentConfig.new(
      :plugin_name => 'synth_instr_3',
      :initial_settings => "blend"
    ),
  }
)

File.open("song1.yml", "w") do |file|
  file.write arrangement.to_yaml
end
