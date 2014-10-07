require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches
include Articulations

score = Score.new(
  Meter.new(4,"1/4".to_r),
  120,
  program: Program.new([ 0...4.0, 0...4.0 ]),
  parts: {
    1 => Part.new(
      Dynamics::MF,
      notes: [
        Note::dotted_quarter([C2]),
        Note::quarter([Eb2]),
        Note.new("5/16".to_r,[F2]),
        Note.new("1/16".to_r, [Eb2]),
        # 1.0
        Note::eighth,
        Note::quarter([C2]),
        Note::quarter([Eb2]),
        Note::dotted_quarter,
        # 2.0
        Note::dotted_quarter([C2]),
        Note::quarter([Eb2]),
        Note.new("5/16".to_r,[F2]),
        Note.new("1/16".to_r, [Eb2]),
        # 3.0
        Note::eighth,
        Note::quarter([C2]),
        Note::quarter([Eb2]),
      ]
    ), 
    2 => Part.new(
      Dynamics::MF,
      notes: [
        # 0.0
        Note::eighth,
        Note::eighth([Bb3]),
        Note::eighth([Bb3]),
        Note::eighth([Bb3]),
        Note::eighth([Bb3]),
        Note::quarter([C4]),
        Note::quarter([A3]),
        Note::eighth([G3]),
        Note::eighth([F3]),
        Note.new("5/16".to_r, [G3], articulation: SLUR),
        Note.new("1/16".to_r, [F3], articulation: SLUR),
        Note::eighth([E3]),
        Note::eighth,
        # 2.0
        Note::eighth,
        Note::eighth([Bb3]),
        Note::eighth([Bb3]),
        Note::eighth([Bb3]),
        Note::eighth([Bb3]),
        Note::quarter([C4]),
        Note::eighth([A3]),
        Note::eighth([E4]),
        Note::eighth([E4], articulation: SLUR),
        Note::eighth([D4], articulation: SLUR),
        Note::eighth([C4]),
      ]
    )
  }
)

File.open("song1.yml", "w") do |file|
  file.write score.to_yaml
end
