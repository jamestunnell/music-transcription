require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches

score = Score.new(
  Meter.new(4,"1/4".to_r),
  120,
  program: Program.new([ 0...4.0, 0...4.0 ]),
  parts: {
    1 => Part.new(
      Dynamics::MF,
      notes: [
        Note::DottedQuarter.new([C2]),
        Note::Quarter.new([Eb2]),
        Note.new("5/16".to_r,[F2]),
        Note.new("1/16".to_r, [Eb2]),
        # 1.0
        Note::Eighth.new,
        Note::Quarter.new([C2]),
        Note::Quarter.new([Eb2]),
        Note::DottedQuarter.new,
        # 2.0
        Note::DottedQuarter.new([C2]),
        Note::Quarter.new([Eb2]),
        Note.new("5/16".to_r,[F2]),
        Note.new("1/16".to_r, [Eb2]),
        # 3.0
        Note::Eighth.new,
        Note::Quarter.new([C2]),
        Note::Quarter.new([Eb2]),
      ]
    ), 
    2 => Part.new(
      Dynamics::MF,
      notes: [
        # 0.0
        Note::Eighth.new,
        Note::Eighth.new([Bb3]),
        Note::Eighth.new([Bb3]),
        Note::Eighth.new([Bb3]),
        Note::Eighth.new([Bb3]),
        Note::Quarter.new([C4]),
        Note::Quarter.new([A3]),
        Note::Eighth.new([G3]),
        Note::Eighth.new([F3]),
        Note.new("5/16".to_r, [G3], links: { G3 => Link::Slur.new(F3) }),
        Note.new("1/16".to_r, [F3], links: { F3 => Link::Slur.new(E3) }),
        Note::Eighth.new([E3]),
        Note::Eighth.new,
        # 2.0
        Note::Eighth.new,
        Note::Eighth.new([Bb3]),
        Note::Eighth.new([Bb3]),
        Note::Eighth.new([Bb3]),
        Note::Eighth.new([Bb3]),
        Note::Quarter.new([C4]),
        Note::Eighth.new([A3]),
        Note::Eighth.new([E4]),
        Note::Eighth.new([E4], links: { E4 => Link::Slur.new(D4) }),
        Note::Eighth.new([D4], links: { D4 => Link::Slur.new(C4) }),
        Note::Eighth.new([C4]),
      ]
    )
  }
)

File.open("song1.yml", "w") do |file|
  file.write score.to_yaml
end
