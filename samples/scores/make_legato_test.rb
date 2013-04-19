require 'musicality'
include Musicality

score_hash = {
  :program => {
    :segments => [0...4.0]
  },
  :beats_per_minute_profile => { :start_value => 120.0 },
  :parts => {
    1 => {
      :notes => [
        { :duration => 0.25, :intervals => [ { :pitch => C3 } ] },
        { :duration => 0.25, :intervals => [ { :pitch => D3 } ] },
        { :duration => 0.25, :intervals => [ { :pitch => E3 } ] },
        { :duration => 0.25, :intervals => [ { :pitch => F3 } ] },
        { :duration => 0.25, :intervals => [ { :pitch => E3 } ] },
        { :duration => 0.25, :intervals => [ { :pitch => D3 } ] },
        { :duration => 0.5, :intervals => [ { :pitch => C3 } ] },
        { :duration => 0.25, :intervals => [ { :pitch => C3, :link => legato(D3) } ] },
        { :duration => 0.25, :intervals => [ { :pitch => D3, :link => legato(E3) } ] },
        { :duration => 0.25, :intervals => [ { :pitch => E3, :link => legato(F3) } ] },
        { :duration => 0.25, :intervals => [ { :pitch => F3, :link => legato(E3) } ] },
        { :duration => 0.25, :intervals => [ { :pitch => E3, :link => legato(D3) } ] },
        { :duration => 0.25, :intervals => [ { :pitch => D3, :link => legato(C3) } ] },
        { :duration => 0.5, :intervals => [ { :pitch => C3 } ] },
      ]
    }
  }
}

score = Score.new score_hash
ScoreFile.save score, "legato_test.yml"

