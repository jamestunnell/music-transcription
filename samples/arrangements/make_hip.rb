require 'musicality'
require 'yaml'

include Musicality

bass_riff = [
  # 0.0
  note(Rational(1,6), [ interval(Bb2) ]),
  note(Rational(1,4)),
  note(Rational(1,3), [ interval(Ab2) ]),
  note(Rational(1,6), [ interval(F2) ]),
  note(Rational(1,12), [ interval(Ab2) ]),
  # 1.0
  note(Rational(1,6), [ interval(Bb2) ]),
  note(Rational(1,4)),
  note(Rational(1,3), [ interval(Ab2) ]),
  note(Rational(1,4), [ interval(Ab2) ]),
]

lead_riff = [
  # 0.0
  note(Rational(1,6), [ interval(Bb3) ]),
  note(Rational(1,4)),
  note(Rational(1,12), [ interval(Db4, tie(Db4))]),
  note(Rational(1,6), [ interval(Db4, tie(Db4))]),
  note(Rational(1,36), [ interval(Db4)]),
  note(Rational(1,36), [ interval(Eb4)]),
  note(Rational(1,36), [ interval(Db4)]),
  note(Rational(1,6), [ interval(Ab3)]),
  note(Rational(1,12), [ interval(Db4)]),
  # 1.0
  note(Rational(1,6), [ interval(Bb3) ]),
  note(Rational(1,4)),
  note(Rational(1,12), [ interval(Db4, tie(Db4))]),
  note(Rational(1,4), [ interval(Db4, tie(Db4))]),
  note(Rational(1,8), [ interval(Db4, portamento(C4))]),
  note(Rational(1,8), [ interval(C4)]),
]

whole_step = Pitch.new(:semitone => 2)
bass_notes = bass_riff + bass_riff.map {|note| note.transpose(whole_step) }
lead_notes = lead_riff + lead_riff.map {|note| note.transpose(whole_step) }

arrangement = Arrangement.new(
  :score => TempoScore.new(
    :program => Program.new(
      :segments => [0...2, 0...2,2...4,0...2]
    ),
    :tempo_profile => profile(tempo(120)),
    :parts => {
      "lead" => Part.new(
        :notes => lead_notes,
        :loudness_profile => profile(0.5)
      ),
      "bass" => Part.new(
        :notes => bass_notes,
        :loudness_profile => profile(0.125)
      )
    }
  ),
  :instrument_configs => {
    'bass' => InstrumentConfig.new(
      :plugin_name => "synth_instr_1",
      :initial_settings => ["sawtooth"]
    ),
    'lead' => InstrumentConfig.new(
      :plugin_name => "synth_instr_3",
      :initial_settings => ["blend", "very short attack", "med decay"]
    ),
  }
)

File.open('hip.yml','w') do |file|
  file.write arrangement.to_yaml
end