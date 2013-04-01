require 'musicality'
include Musicality

C3 = PitchConstants::C3
D3 = PitchConstants::D3
E3 = PitchConstants::E3
F3 = PitchConstants::F3

score_hash = {
  :program => {
    :segments => [0...4.0]
  },
  :beats_per_minute_profile => { :start_value => 120.0 },
  :parts => {
    1 => {
      :loudness_profile => { :start_value => 0.5 },
      :notes => [
        { :duration => 0.75, :intervals => [ { :pitch => C3, :link => portamento(F3) } ] },
        { :duration => 0.75, :intervals => [ { :pitch => F3, :link => portamento(C3) } ] },
        { :duration => 0.5, :intervals => [ { :pitch => C3 } ] }
      ]
    }
  }
}

score = Score.new score_hash
ScoreFile.save score, "portamento_test.yml"

