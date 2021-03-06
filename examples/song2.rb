require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches
include Meters

score = MeasureScore.new(FOUR_FOUR, Tempo::BPM.new(120)) do |s|
  s.program = Program.new([0...4.0, 0...4.0 ])
  
  s.parts[1] = Part.new(Dynamics::MF) do |p|
    p.notes = "1C4 1Bb3 1Ab3 /2G3 /2Bb3".to_notes
  end
  
  s.parts[2] = Part.new(Dynamics::MF) do |p|
    p.notes = "3/8E5 1D5 1C5 5/8C5 /2C5 /2D5".to_notes
  end
  
  s.parts[3] = Part.new(Dynamics::MF) do |p|
    p.notes = "/8 /4G5 /2F5 /4 /4F5 /2Eb5 /4 /4Eb5 /2Eb5 /8 /2Eb5 /2F5".to_notes
  end
end

name = File.basename(__FILE__,".rb")

File.open("#{name}.yml", "w") do |file|
  file.write score.to_yaml
end

File.open("#{name}_packed.yml", "w") do |file|
  file.write pack_score(score).to_yaml
end
