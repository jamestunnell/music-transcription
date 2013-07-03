require 'musicality'
require 'yaml'

include Musicality

arrangement = Arrangement.new(
  :score => TempoScore.new(
    :program => Program.new(
      :segments => [0...8.0]
    ),
    :tempo_profile => profile(tempo(120)),
    :parts => {
      "bass" => Part.new(
        :notes => [
          # 0.0
          note(0.25, [ interval(Eb2) ]),
          note(0.25),
          note(0.25, [ interval(Bb2) ]),
          note(0.25),
          note(0.25, [ interval(Eb2) ]),
          note(0.125),
          note(0.125, [ interval(B2) ]),
          note(0.25, [ interval(Bb2) ]),
          note(0.25, [ interval(Ab2) ]),
          
          # 2.0
          note(0.25, [ interval(Eb2) ]),
          note(0.25),
          note(0.25, [ interval(Bb2) ]),
          note(0.25),
          note(0.25, [ interval(Eb2) ]),
          note(0.125),
          note(0.125, [ interval(B2) ]),
          note(0.25, [ interval(Bb2) ]),
          note(0.25, [ interval(Ab2) ]),
          
          # 4.0
          note(0.25, [ interval(Bb2) ]),
          note(0.125),
          note(0.125, [ interval(F3, tie(F3)) ]),
          note(0.5, [ interval(F3) ]),
          note(0.25, [ interval(Bb2) ]),
          note(0.125),
          note(0.125, [ interval(F3, tie(F3)) ]),
          note(0.5, [ interval(F3) ]),
  
          # 6.0
          note(0.25, [ interval(B2) ]),
          note(0.125),
          note(0.125, [ interval(Gb3, tie(Gb3)) ]),
          note(0.5, [ interval(Gb3) ]),
          note(0.25, [ interval(B2) ]),
          note(0.125),
          note(0.125, [ interval(Gb3, tie(Gb3)) ]),
          note(0.5, [ interval(Gb3) ]),
          
          #8.0
        ]
      )
    }
  ),
  :instrument_configs => {
    "bass" => InstrumentConfig.new(
      :plugin_name => 'synth_instr_3',
      :initial_settings => "blend"
    ),
  }
)

File.open("missed_connection.yml", "w") do |file|
  file.write arrangement.to_yaml
end
