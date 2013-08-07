require 'music-transcription'
require 'yaml'

include Music::Transcription

arrangement = Arrangement.new(
  :score => TempoScore.new(
    :program => Program.new(
      :segments => [0...4.0, 0...4.0 ]
    ),
    :tempo_profile => profile(tempo(120)),
    :parts => {
      1 => Part.new(
        :notes => [
          note(1.0, [ interval(C4) ]),
          note(1.0, [ interval(Bb3) ]),
          note(1.0, [ interval(Ab3) ]),
          note(0.5, [ interval(G3) ]),
          note(0.5, [ interval(Bb3) ]),
        ]
      ), 
      2 => Part.new(
        :notes => [
          note(0.375, [ interval(E5) ]),
          note(1.0, [ interval(D5)]),
          note(1.0, [ interval(C5)]),
          note(0.625, [ interval(C5)]),
          note(0.5, [ interval(C5)]),
          note(0.5, [ interval(D5)])
        ]
      ),
      3 => Part.new(
        :notes => [
          note(0.125),
          note(0.25, [interval(G5)] ),
          note(0.5, [interval(F5)] ),
          note(0.25),
          note(0.25, [interval(F5)] ),
          note(0.5, [interval(Eb5)] ),
          note(0.25),
          note(0.25, [interval(Eb5)] ),
          note(0.5, [interval(Eb5)] ),
          note(0.125),
          note(0.5, [interval(Eb5)] ),
          note(0.5, [interval(F5)] ),
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
    3 => InstrumentConfig.new(
      :plugin_name => 'synth_instr_3',
      :initial_settings => "blend"
    )
  }
)

File.open("song2.yml", "w") do |file|
  file.write arrangement.to_yaml
end

