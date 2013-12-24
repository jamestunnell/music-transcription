require 'rspec'
require 'music-transcription'

include Music::Transcription

class Samples
  SAMPLE_PART = Part.new(
    :notes => [ Note.new(0.25, [ C1, D1 ]) ],
    :loudness_profile => Profile.new(0.5, 1.0 => linear_change(1.0, 2.0))
  )
end