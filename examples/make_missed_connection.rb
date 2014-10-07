require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches
include Articulations

score = Score.new(
  Meter.new(4,"1/4".to_r),
  120,
  program: Program.new([0...8.0]),
  parts: {
    "bass" => Part.new(
      Dynamics::MF,
      notes: [
        # 0.0
        Note::quarter([Eb2]),
        Note::quarter,
        Note::quarter([Bb2]),
        Note::quarter,
        Note::quarter([Eb2]),
        Note::eighth,
        Note::eighth([B2]),
        Note::quarter([Bb2]),
        Note::quarter([Ab2]),
        
        # 2.0
        Note::quarter([Eb2]),
        Note::quarter,
        Note::quarter([Bb2]),
        Note::quarter,
        Note::quarter([Eb2]),
        Note::eighth,
        Note::eighth([B2]),
        Note::quarter([Bb2]),
        Note::quarter([Ab2]),
        
        # 4.0
        Note::quarter([Bb2]),
        Note::eighth,
        Note::eighth([F3], articulation: SLUR),
        Note::half([F3]),
        Note::quarter([Bb2]),
        Note::eighth,
        Note::eighth([F3], articulation: SLUR),
        Note::half([F3]),

        # 6.0
        Note::quarter([B2]),
        Note::eighth,
        Note::eighth([Gb3], articulation: SLUR),
        Note::half([Gb3]),
        Note::quarter([B2]),
        Note::eighth,
        Note::eighth([Gb3], articulation: SLUR),
        Note::half([Gb3]),
        
        #8.0
      ]
    )
  }
)

File.open("missed_connection.yml", "w") do |file|
  file.write score.to_yaml
end
