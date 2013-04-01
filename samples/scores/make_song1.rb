require 'musicality'
include Musicality

C2 = PitchConstants::C2
Eb2 = PitchConstants::Eb2
F2 = PitchConstants::F2

E3 = PitchConstants::E3
F3 = PitchConstants::F3
G3 = PitchConstants::G3
A3 = PitchConstants::A3
Bb3 = PitchConstants::Bb3
C4 = PitchConstants::C4
D4 = PitchConstants::D4
E4 = PitchConstants::E4

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
        { :duration => 0.375, :intervals => [{ :pitch => C2 } ]},
        { :duration => 0.25, :intervals => [{ :pitch => Eb2 } ]},
        { :duration => 0.3125, :intervals => [{ :pitch => F2 } ]},
        { :duration => 0.0625, :intervals => [{ :pitch => Eb2 } ]},
        # 1.0
        { :duration => 0.125 },
        { :duration => 0.25, :intervals => [{ :pitch => C2 } ]},
        { :duration => 0.25, :intervals => [{ :pitch => Eb2 } ]},
        { :duration => 0.375 },
        # 2.0
        { :duration => 0.375, :intervals => [{ :pitch => C2 } ]},
        { :duration => 0.25, :intervals => [{ :pitch => Eb2 } ]},
        { :duration => 0.3125, :intervals => [{ :pitch => F2 } ]},
        { :duration => 0.0625, :intervals => [{ :pitch => Eb2 } ]},
        # 3.0
        { :duration => 0.125 },
        { :duration => 0.25, :intervals => [{ :pitch => C2 } ]},
        { :duration => 0.25, :intervals => [{ :pitch => Eb2 } ]},
      ]
    }, 
    2 => {
      :notes => [
        # 0.0
        { :duration => 0.125 },
        { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
        { :duration => 0.25, :intervals => [{ :pitch => C4 } ]},
        { :duration => 0.25, :intervals => [{ :pitch => A3 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => G3 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => F3 } ]},
        { :duration => 0.3125, :intervals => [{ :pitch => G3, :link => slur(F3) } ]},
        { :duration => 0.0625, :intervals => [{ :pitch => F3, :link => slur(E3) } ]},
        { :duration => 0.125, :intervals => [{ :pitch => E3 } ]},
        { :duration => 0.125 },
        # 2.0
        { :duration => 0.125 },
        { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
        { :duration => 0.25, :intervals => [{ :pitch => C4 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => A3 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => E4 } ]},
        { :duration => 0.125, :intervals => [{ :pitch => E4, :link => slur(D4) } ]},
        { :duration => 0.125, :intervals => [{ :pitch => D4, :link => slur(C4) } ]},
        { :duration => 0.125, :intervals => [{ :pitch => C4 } ]},
      ]
    }
  }
}

score = Score.new score_hash
ScoreFile.save score, "song1.yml"
