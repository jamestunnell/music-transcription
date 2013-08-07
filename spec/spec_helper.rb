require 'rspec'
require 'music-transcription'

include Music::Transcription

class Samples
  SAMPLE_PART = Part.new(
    :notes => [
      Note.new(
        :duration => 0.25,
        :intervals => [
          Interval.new( :pitch => C1 ),
          Interval.new( :pitch => D1 ),
        ]
      )
    ],
    :loudness_profile => profile(
      0.5, {
        1.0 => linear_change(1.0, 2.0)
      }
    )
  )
end