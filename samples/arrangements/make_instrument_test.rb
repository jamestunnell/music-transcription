require 'music-transcription'
require 'yaml'

include Music::Transcription

arrangement = Arrangement.new(
  :score => TempoScore.new(
    :program => Program.new(
      :segments => [0...1.0]
    ),
    :tempo_profile => profile(tempo(120)),
    :parts => {
      1 => Part.new(
        :loudness_profile => profile(0.5),
        :notes => [
          note(0.125, [ interval(C3) ] ),
          note(0.125, [ interval(D3) ] ),
          note(0.25, [ interval(C3) ] ),
          note(0.50, [ interval(C3), interval(E3) ] ),
        ]
      )
    }
  ),
  :instrument_configs => {
    1 => InstrumentConfig.new(
      :plugin_name => 'synth_instr_3',
      :initial_settings => ["blend", "short attack", "long decay"]
    ),
  }
)

File.open("instrument_test.yml", "w") do |file|
  file.write arrangement.to_yaml
end
