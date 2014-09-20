require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches

score = Score.new(
  Meter.new(4,"1/4".to_r),
  120,
  program: Program.new([0...8.0]),
  parts: {
    "bass" => Part.new(
      Dynamics::MF,
      notes: [
        # 0.0
        Note::Quarter.new([Eb2]),
        Note::Quarter.new,
        Note::Quarter.new([Bb2]),
        Note::Quarter.new,
        Note::Quarter.new([Eb2]),
        Note::Eighth.new,
        Note::Eighth.new([B2]),
        Note::Quarter.new([Bb2]),
        Note::Quarter.new([Ab2]),
        
        # 2.0
        Note::Quarter.new([Eb2]),
        Note::Quarter.new,
        Note::Quarter.new([Bb2]),
        Note::Quarter.new,
        Note::Quarter.new([Eb2]),
        Note::Eighth.new,
        Note::Eighth.new([B2]),
        Note::Quarter.new([Bb2]),
        Note::Quarter.new([Ab2]),
        
        # 4.0
        Note::Quarter.new([Bb2]),
        Note::Eighth.new,
        Note::Eighth.new([F3], links: { F3 => Link::Slur.new(F3)}),
        Note::Half.new([F3]),
        Note::Quarter.new([Bb2]),
        Note::Eighth.new,
        Note::Eighth.new([F3], links: { F3 => Link::Slur.new(F3)}),
        Note::Half.new([F3]),

        # 6.0
        Note::Quarter.new([B2]),
        Note::Eighth.new,
        Note::Eighth.new([Gb3], links: { Gb3 => Link::Slur.new(Gb3)}),
        Note::Half.new([Gb3]),
        Note::Quarter.new([B2]),
        Note::Eighth.new,
        Note::Eighth.new([Gb3], links: { Gb3 => Link::Slur.new(Gb3)}),
        Note::Half.new([Gb3]),
        
        #8.0
      ]
    )
  }
)

File.open("missed_connection.yml", "w") do |file|
  file.write score.to_yaml
end
