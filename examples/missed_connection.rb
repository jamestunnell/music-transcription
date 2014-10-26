require 'music-transcription'
require 'yaml'

include Music::Transcription
include Pitches
include Articulations
include Meters
include Parsing

score = Score.new(FOUR_FOUR, 120) do |s|
  s.program = Program.new([0...2,0...6])
  s.parts["bass"] = Part.new(Dynamics::MF) do |p|
    p.notes =  notes("/4Eb2 /4 /4Bb2 /4 /4Eb2 /8 /8B2 /4Bb2 /4Ab2")
    p.notes += notes("/4Bb2 /8 /8F3= /2F3 /4Bb2 /8 /8F3= /2F3")
    p.notes += notes("/4B2 /8 /8Gb3= /2Gb3 /8 /8Gb3= /2Gb3")
  end
end

name = File.basename(__FILE__,".rb")

File.open("#{name}.yml", "w") do |file|
  file.write score.to_yaml
end

File.open("#{name}_packed.yml", "w") do |file|
  file.write score.pack.to_yaml
end