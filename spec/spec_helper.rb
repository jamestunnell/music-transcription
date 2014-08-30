require 'rspec'
require 'music-transcription'

include Music::Transcription
include Music::Transcription::Pitches

class Samples
  SAMPLE_PART = Part.new(
    notes: [ Note::Quarter.new([ C1, D1 ]), Note::Quarter.new([ C2, D2 ]), Note::Whole.new([ C3, D3 ]) ],
    dynamic_profile: Profile.new(Dynamics::P, {1.0 => Change::Immediate.new(Dynamics::MP)})
  )
end