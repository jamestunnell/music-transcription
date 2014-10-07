require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches

score = Score.new(
  Meter.new(4,"1/4".to_r),
  120,
  :program => Program.new(
    :segments => [0...4.0, 0...4.0 ]
  ),
  :parts => {
    1 => Part.new(
      Dynamics::MF,
      notes: [
        Note::whole([C4]),
        Note::whole([Bb3]),
        Note::whole([Ab3]),
        Note::half([G3]),
        Note::half([Bb3]),
      ]
    ), 
    2 => Part.new(
      Dynamics::MF,
      notes: [
        Note::dotted_quarter([E5]),
        Note::whole([D5]),
        Note::whole([C5]),
        Note::new("5/8".to_r, [C5]),
        Note::half([C5]),
        Note::half([D5]),
      ]
    ),
    3 => Part.new(
      Dynamics::MF,
      notes: [
        Note::eighth,
        Note::quarter([G5]),
        Note::half([F5]),
        Note::quarter,
        Note::quarter([F5]),
        Note::half([Eb5]),
        Note::quarter,
        Note::quarter([Eb5]),
        Note::half([Eb5]),
        Note::eighth,
        Note::half([Eb5]),
        Note::half([F5]),
      ]
    )
  }
)

File.open("song2.yml", "w") do |file|
  file.write score.to_yaml
end

