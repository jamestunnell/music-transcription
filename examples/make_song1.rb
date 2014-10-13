require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches
include Articulations
include Meters
include Parsing

score = Score.new(FOUR_FOUR, 120) do |s|
  s.program = Program.new([ 0...4.0, 0...4.0 ])
  
  s.parts[1] = Part.new(Dynamics::MF) do |p|
    p.notes = notes("3/8C2 /4Eb2 5/16F2 /16Eb2 \
                     /8 /4C2 /4Eb2 3/8 \
                     3/8C2 /4Eb2 5/16F2 /16Eb2 \
                     /8 /4C2 /4Eb2")
  end
  
  s.parts[2] = Part.new(Dynamics::MF) do |p|
    p.notes = notes("/8 /8Bb3 /8Bb3 /8Bb3 /8Bb3 /4C4 /4A3 /8G3 /8F3 5/16=G3 /16=F3 /8E3 /8 \
                     /8 /8Bb3 /8Bb3 /8Bb3 /8Bb3 /4C4 /8A3 /8E4 /8=E4 /8=D4 /8C4")
  end
end

File.open("song1.yml", "w") do |file|
  file.write score.to_yaml
end