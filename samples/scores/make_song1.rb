require 'musicality'

C2 = Musicality::PitchConstants::C2
Eb2 = Musicality::PitchConstants::Eb2
F2 = Musicality::PitchConstants::F2

E3 = Musicality::PitchConstants::E3
F3 = Musicality::PitchConstants::F3
G3 = Musicality::PitchConstants::G3
A3 = Musicality::PitchConstants::A3
Bb3 = Musicality::PitchConstants::Bb3
C4 = Musicality::PitchConstants::C4
D4 = Musicality::PitchConstants::D4
E4 = Musicality::PitchConstants::E4

score_hash = {
  :program => {
    :segments => [
      0...4.0,
      0...4.0
    ]
  },
  :start_tempo => { 
    :beats_per_minute => 120, 
    :beat_duration => 0.25, 
    :offset => 0.0
  },
  :parts => [
    { 
      :start_dynamic => {
        :offset => 0.0,
        :loudness => 0.5
      },
      :sequences => [
        { :offset => 0.0, :notes => [
            { :duration => 0.375, :pitches => [C2] },
            { :duration => 0.25, :pitches => [Eb2] },
            { :duration => 0.3125, :pitches => [F2] },
            { :duration => 0.0625, :pitches => [Eb2] }
          ]
        }, { :offset => 1.125, :notes => [
            { :duration => 0.25, :pitches => [C2] },
            { :duration => 0.25, :pitches => [Eb2] }
          ]
        }, { :offset => 2.0, :notes => [
            { :duration => 0.375, :pitches => [C2] },
            { :duration => 0.25, :pitches => [Eb2] },
            { :duration => 0.3125, :pitches => [F2] },
            { :duration => 0.0625, :pitches => [Eb2] }
          ]
        }, { :offset => 3.125, :notes => [
            { :duration => 0.25, :pitches => [C2] },
            { :duration => 0.25, :pitches => [Eb2] }
          ]
        }
      ]
    }, 
    { 
      :start_dynamic => {
        :offset => 0.0,
        :loudness => 0.5
      },
      :sequences => [
        { :offset => 0.125, :notes => [
            { :duration => 0.125, :pitches => [Bb3] },
            { :duration => 0.125, :pitches => [Bb3] },
            { :duration => 0.125, :pitches => [Bb3] },
            { :duration => 0.125, :pitches => [Bb3] },
            { :duration => 0.25, :pitches => [C4] },
            { :duration => 0.25, :pitches => [A3] },
            { :duration => 0.125, :pitches => [G3] },
            { :duration => 0.125, :pitches => [F3] },
            { :duration => 0.3125, :pitches => [G3] },
            { :duration => 0.0625, :pitches => [F3] },
            { :duration => 0.125, :pitches => [E3] }
          ]
        },
        { :offset => 2.125, :notes => [
            { :duration => 0.125, :pitches => [Bb3] },
            { :duration => 0.125, :pitches => [Bb3] },
            { :duration => 0.125, :pitches => [Bb3] },
            { :duration => 0.125, :pitches => [Bb3] },
            { :duration => 0.25, :pitches => [C4] },
            { :duration => 0.125, :pitches => [A3] },
            { :duration => 0.125, :pitches => [E4] },
            { :duration => 0.125, :pitches => [E4] },
            { :duration => 0.125, :pitches => [D4] },
            { :duration => 0.125, :pitches => [C4] },
          ]
        }
      ]
    }
  ]
}

score = Musicality::Score.make_from_hash score_hash
Musicality::ScoreFile.save score, "song1.yaml"

