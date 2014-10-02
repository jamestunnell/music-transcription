require 'rspec'
require 'music-transcription'

include Music::Transcription
include Pitches
include Meters
include Articulations

class Samples
  SAMPLE_PART = Part.new(
    Dynamics::P,
    notes: [
      Note::quarter([ C1, D1 ]),
      Note::quarter([ C2, D2 ]),
      Note::whole([ C3, D3 ])
    ],
    dynamic_changes: {1.0 => Change::Immediate.new(Dynamics::MP)}
  )
end

RSpec::Matchers.define :be_valid do
  match do |obj|
    obj.valid?
  end
end

RSpec::Matchers.define :be_invalid do
  match do |obj|
    obj.invalid?
  end
end
