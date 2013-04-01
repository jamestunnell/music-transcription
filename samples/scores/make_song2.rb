require 'musicality'
include Musicality

G3 = PitchConstants::G3
Ab3 = PitchConstants::Ab3
Bb3 = PitchConstants::Bb3
C4 = PitchConstants::C4

B5 = PitchConstants::B5
C5 = PitchConstants::C5
Db5 = PitchConstants::Db5
D5 = PitchConstants::D5
Eb5 = PitchConstants::Eb5
E5 = PitchConstants::E5
F5 = PitchConstants::F5
G5 = PitchConstants::G5

score_hash = {
  :program => {
    :segments => [
      0...4.0,
      0...4.0  
    ]
  },
  :beats_per_minute_profile => { :start_value => 120.0 },
  :parts => {
    1 => {
      :notes => [
        { :duration => 1.0, :intervals => [ {:pitch => C4} ]},
        { :duration => 1.0, :intervals => [ {:pitch => Bb3} ]},
        { :duration => 1.0, :intervals => [ {:pitch => Ab3} ]},
        { :duration => 0.5, :intervals => [ {:pitch => G3} ]},
        { :duration => 0.5, :intervals => [ {:pitch => Bb3} ]},
      ]
    }, 
    2 => { 
      :notes => [
        { :duration => 0.375, :intervals => [ {:pitch => E5 } ]},
        { :duration => 1.0, :intervals => [ {:pitch => D5 }]},
        { :duration => 1.0, :intervals => [ {:pitch => C5 }]},
        { :duration => 0.625, :intervals => [ {:pitch => C5 }]},
        { :duration => 0.5, :intervals => [ {:pitch => C5 }]},
        { :duration => 0.5, :intervals => [ {:pitch => D5 }]}
      ]
    },
    3 => {
      :notes => [
        { :duration => 0.125 },
        { :duration => 0.25, :intervals => [{:pitch => G5 }]},
        { :duration => 0.5, :intervals => [{:pitch => F5 }]},
        { :duration => 0.25 },
        { :duration => 0.25, :intervals => [{:pitch => F5 }]},
        { :duration => 0.5, :intervals => [{:pitch => Eb5 }]},
        { :duration => 0.25 },
        { :duration => 0.25, :intervals => [{:pitch => Eb5 }]},
        { :duration => 0.5, :intervals => [{:pitch => Eb5 }]},
        { :duration => 0.125 },
        { :duration => 0.5, :intervals => [{:pitch => Eb5 }]},
        { :duration => 0.5, :intervals => [{:pitch => F5 }]},
      ]
    }
  }
}

score = Score.new score_hash
ScoreFile.save score, "song2.yml"

