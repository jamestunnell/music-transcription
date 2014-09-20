require 'music-transcription'
require 'yaml'

include Music::Transcription

score = TempoScore.new(
  Meter.new(4,"1/4".to_r),
  120,
  :program => Program.new(
    :segments => [0...4.0, 0...4.0 ]
  ),
  :parts => {
    1 => Part.new(
      Dynamics::MF
      notes: [
        Note::Whole.new([C4]),
        Note::Whole.new([Bb3]),
        Note::Whole.new([Ab3]),
        Note::Half.new([G3]),
        Note::Half.new([Bb3]),
      ]
    ), 
    2 => Part.new(
      Dynamics::MF,
      notes: [
        Note::DottedQuarter.new([E5]),
        Note::Whole.new([D5]),
        Note::Whole.new([C5]),
        Note::new("5/8".to_r, [C5]),
        Note::Half.new([C5]),
        Note::Half.new([D5]),
      ]
    ),
    3 => Part.new(
      Dynamics::MF,
      notes: [
        Note::Eighth.new,
        Note::Quarter.new([G5]),
        Note::Half.new([F5]),
        Note::Quarter.new,
        Note::Quarter.new([F5])
        Note::Half.new([Eb5]),
        Note::Quarter.new,
        Note::Quarter.new([Eb5]),
        Note::Half.new([Eb5]),
        Note::Eighth.new,
        Note::Half.new([Eb5]),
        Note::Half.new([F5]),
      ]
    )
  }
)

File.open("song2.yml", "w") do |file|
  file.write score.to_yaml
end

