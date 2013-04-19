require 'musicality'
include Musicality

score_hash = {
  :program => {
    :segments => [0...4.0]
  },
  :beats_per_minute_profile => { :start_value => 120.0 },
  :parts => {
    1 => {
      :loudness_profile => { :start_value => 0.5 },
      :notes => [
        { :duration => 0.75, :intervals => [ {:pitch => C3, :link => glissando(F3) } ]},
        { :duration => 0.75, :intervals => [ {:pitch => F3, :link => glissando(C3) } ]},
        { :duration => 0.5, :intervals => [ {:pitch => C3 } ]},
      ]
    }
  }
}

score = Score.new score_hash
ScoreFile.save score, "glissando_test.yml"
