require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches
include Articulations

bass_riff = [
  # 0.0
  Note.new(Rational(1,6), [ Bb2 ]),
  Note.new(Rational(1,4)),
  Note.new(Rational(1,3), [ Ab2 ]),
  Note.new(Rational(1,6), [ F2 ]),
  Note.new(Rational(1,12), [ Ab2 ]),
  # 1.0
  Note.new(Rational(1,6), [ Bb2 ]),
  Note::quarter,
  Note.new(Rational(1,3), [ Ab2 ]),
  Note::quarter([ Ab2 ]),
]

lead_riff = [
  # 0.0
  Note.new(Rational(1,6), [ Bb3 ]),
  Note.new(Rational(1,4)),
  Note.new(Rational(1,12), [ Db4 ], articulation: SLUR),
  Note.new(Rational(1,6), [ Db4 ], articulation: SLUR),
  Note.new(Rational(1,36), [ Db4 ]),
  Note.new(Rational(1,36), [ Eb4 ]),
  Note.new(Rational(1,36), [ Db4 ]),
  Note.new(Rational(1,6), [ Ab3 ]),
  Note.new(Rational(1,12), [ Db4 ]),
  # 1.0
  Note.new(Rational(1,6), [ Bb3 ]),
  Note.new(Rational(1,4)),
  Note.new(Rational(1,12), [ Db4 ], articulation: SLUR),
  Note::quarter([ Db4 ], articulation: SLUR),
  Note::eighth([ Db4 ], articulation: SLUR),
  Note::eighth([ C4 ]),
]

whole_step = Pitch.new(:semitone => 2)
bass_notes = bass_riff + bass_riff.map {|note| note.transpose(whole_step) }
lead_notes = lead_riff + lead_riff.map {|note| note.transpose(whole_step) }

score = Score.new(
  Meter.new(4,"1/4".to_r),
  120,
  program: Program.new([0...2, 0...2,2...4,0...2]),
  parts: {
    "lead" => Part.new(
      Dynamics::MF,
      notes: lead_notes
    ),
    "bass" => Part.new(
      Dynamics::MP,
      notes: bass_notes
    )
  }
)

File.open('hip.yml','w') do |file|
  file.write score.to_yaml
end