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
  :beats_per_minute_profile => { :start_value => 120.0 },
  :parts => [
    {
      :loudness_profile => { :start_value => 0.5 },
      :note_sequences => [
        { :offset => 0.0, :notes => [
            { :duration => 0.375, :pitch => C2 },
            { :duration => 0.25, :pitch => Eb2 },
            { :duration => 0.3125, :pitch => F2 },
            { :duration => 0.0625, :pitch => Eb2 }
          ]
        }, { :offset => 1.125, :notes => [
            { :duration => 0.25, :pitch => C2 },
            { :duration => 0.25, :pitch => Eb2 }
          ]
        }, { :offset => 2.0, :notes => [
            { :duration => 0.375, :pitch => C2 },
            { :duration => 0.25, :pitch => Eb2 },
            { :duration => 0.3125, :pitch => F2 },
            { :duration => 0.0625, :pitch => Eb2 }
          ]
        }, { :offset => 3.125, :notes => [
            { :duration => 0.25, :pitch => C2 },
            { :duration => 0.25, :pitch => Eb2 }
          ]
        }
      ],
      :id => "1",
    }, 
    {
      :loudness_profile => { :start_value => 0.5 },
      :note_sequences => [
        { :offset => 0.125, :notes => [
            { :duration => 0.125, :pitch => Bb3 },
            { :duration => 0.125, :pitch => Bb3 },
            { :duration => 0.125, :pitch => Bb3 },
            { :duration => 0.125, :pitch => Bb3 },
            { :duration => 0.25, :pitch => C4 },
            { :duration => 0.25, :pitch => A3 },
            { :duration => 0.125, :pitch => G3 },
            { :duration => 0.125, :pitch => F3 },
            { :duration => 0.3125, :pitch => G3, :relationship => Musicality::Note::RELATIONSHIP_SLUR},
            { :duration => 0.0625, :pitch => F3, :relationship => Musicality::Note::RELATIONSHIP_SLUR },
            { :duration => 0.125, :pitch => E3 }
          ]
        },
        { :offset => 2.125, :notes => [
            { :duration => 0.125, :pitch => Bb3 },
            { :duration => 0.125, :pitch => Bb3 },
            { :duration => 0.125, :pitch => Bb3 },
            { :duration => 0.125, :pitch => Bb3 },
            { :duration => 0.25, :pitch => C4 },
            { :duration => 0.125, :pitch => A3 },
            { :duration => 0.125, :pitch => E4 },
            { :duration => 0.125, :pitch => E4, :relationship => Musicality::Note::RELATIONSHIP_SLUR },
            { :duration => 0.125, :pitch => D4, :relationship => Musicality::Note::RELATIONSHIP_SLUR },
            { :duration => 0.125, :pitch => C4 },
          ]
        }
      ],
      :id => "2",
    }
  ]
}

score = Musicality::Score.make_from_hash score_hash
Musicality::ScoreFile.save score, "song1.yaml"

