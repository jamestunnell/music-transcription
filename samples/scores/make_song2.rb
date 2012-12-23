require 'musicality'

G3 = Musicality::PitchConstants::G3
Ab3 = Musicality::PitchConstants::Ab3
Bb3 = Musicality::PitchConstants::Bb3
C4 = Musicality::PitchConstants::C4

B5 = Musicality::PitchConstants::B5
C5 = Musicality::PitchConstants::C5
Db5 = Musicality::PitchConstants::Db5
D5 = Musicality::PitchConstants::D5
Eb5 = Musicality::PitchConstants::Eb5
E5 = Musicality::PitchConstants::E5
F5 = Musicality::PitchConstants::F5
G5 = Musicality::PitchConstants::G5

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
      :start_dynamic => {
        :offset => 0.0,
        :loudness => 0.5
      },
      :note_sequences => [
        { :offset => 0.0, :notes => [
            { :duration => 1.0, :pitch => C4 },
            { :duration => 1.0, :pitch => Bb3 },
            { :duration => 1.0, :pitch => Ab3 },
            { :duration => 0.5, :pitch => G3 },
            { :duration => 0.5, :pitch => Bb3 },
          ]
        }
      ],
      :id => "1",
    }, 
    { 
      :loudness_profile => { :start_value => 0.5 },
      :note_sequences => [
        { :offset => 0.0, :notes => [
            { :duration => 0.375, :pitch => E5 },
            { :duration => 1.0, :pitch => D5 },
            { :duration => 1.0, :pitch => C5 },
            { :duration => 0.625, :pitch => C5 },
            { :duration => 0.5, :pitch => C5 },
            { :duration => 0.5, :pitch => D5 }
          ]
        }
      ],
      :id => "2",
    },
    {
      :loudness_profile => { :start_value => 0.5 },
      :note_sequences => [
        { :offset => 0.125, :notes => [
            { :duration => 0.25, :pitch => G5 },
            { :duration => 0.5, :pitch => F5 }
          ]
        },
        { :offset => 1.125, :notes => [
            { :duration => 0.25, :pitch => F5 },
            { :duration => 0.5, :pitch => Eb5 }
          ]
        },
        { :offset => 2.125, :notes => [
            { :duration => 0.25, :pitch => Eb5 },
            { :duration => 0.5, :pitch => Eb5 }
          ]
        },
        { :offset => 3.01, :notes => [
            { :duration => 0.5, :pitch => Eb5 },
            { :duration => 0.5, :pitch => F5 }
          ]
        }
      ],
      :id => "3",
    }
  ]
}

score = Musicality::Score.make_from_hash score_hash
Musicality::ScoreFile.save score, "song2.yml"

