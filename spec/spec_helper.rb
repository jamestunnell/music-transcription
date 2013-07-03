require 'rspec'
require 'musicality'

include Musicality

# load sample (built-in) instruments to help with testing
INSTRUMENTS.load_plugins './samples/instruments/'

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
    :loudness_profile => Musicality::Profile.new(
      :start_value => 0.5,
      :value_changes => {
        1.0 => Musicality::linear_change(1.0, 2.0)
      }
    )
  )
end