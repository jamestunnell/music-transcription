require 'musicality'
include Musicality

score_hash = {
  :program => {
    :segments => [0...0.5]
  },
  :beats_per_minute_profile => { :start_value => 120.0 },
  :parts => {
    1 => {
      :notes => [
        { :duration => 0.25, :intervals => [ { :pitch => C3 } ] },
        { :duration => 0.25, :intervals => [ { :pitch => D3 } ] },
      ]
    }
  }
}

score = Score.new score_hash
ScoreFile.save score, "instrument_test.yml"

