require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches
include Articulations
include Meters

score = MeasureScore.new(FOUR_FOUR, Tempo::BPM.new(120)) do |s|
  s.program = Program.new([ 0...4.0, 0...4.0 ])
  
  s.parts[1] = Part.new(Dynamics::MF) do |p|
    p.notes = "3/8C2 /4Eb2 5/16F2 /16Eb2 \
               /8 /4C2 /4Eb2 3/8 \
               3/8C2 /4Eb2 5/16F2 /16Eb2 \
               /8 /4C2 /4Eb2".to_notes
  end
  
  s.parts[2] = Part.new(Dynamics::MF) do |p|
    p.notes = "/8 /8Bb3 /8Bb3 /8Bb3 /8Bb3 /4C4 /4A3 /8G3 /8F3 5/16=G3 /16=F3 /8E3 /8 \
               /8 /8Bb3 /8Bb3 /8Bb3 /8Bb3 /4C4 /8A3 /8E4 /8=E4 /8=D4 /8C4".to_notes
  end
end

name = File.basename(__FILE__,".rb")

File.open("#{name}.yml", "w") do |file|
  file.write score.to_yaml
end

File.open("#{name}_packed.yml", "w") do |file|
  file.write pack_score(score).to_yaml
end
