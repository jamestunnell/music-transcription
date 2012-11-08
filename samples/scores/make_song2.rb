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
  :start_tempo => { 
    :beats_per_minute => 120, 
    :beat_duration => 0.25, 
    :offset => 0.0
  },
  :parts => [
    { 
      :instrument => {
        :class_name => "Musicality::SawtoothWave"
      },
      :start_dynamic => {
        :offset => 0.0,
        :loudness => 0.5
      },
      :sequences => [
        { :offset => 0.0, :notes => [
            { :duration => 1.0, :pitches => [C4] },
            { :duration => 1.0, :pitches => [Bb3] },
            { :duration => 1.0, :pitches => [Ab3] },
            { :duration => 0.5, :pitches => [G3] },
            { :duration => 0.5, :pitches => [Bb3] },
          ]
        }
      ]
    }, 
    { 
      :instrument => {
        :class_name => "Musicality::TriangleWave"
      },
      :start_dynamic => {
        :offset => 0.0,
        :loudness => 0.5
      },
      :sequences => [
        { :offset => 0.0, :notes => [
            { :duration => 0.375, :pitches => [E5] },
            { :duration => 1.0, :pitches => [D5] },
            { :duration => 1.0, :pitches => [C5] },
            { :duration => 0.625, :pitches => [C5] },
            { :duration => 0.5, :pitches => [C5] },
            { :duration => 0.5, :pitches => [D5] }
          ]
        }
      ]
    },
    { 
      :instrument => {
        :class_name => "Musicality::TriangleWave"
      },
      :start_dynamic => {
        :offset => 0.0,
        :loudness => 0.5
      },
      :sequences => [
        { :offset => 0.125, :notes => [
            { :duration => 0.25, :pitches => [G5] },
            { :duration => 0.5, :pitches => [F5] }
          ]
        },
        { :offset => 1.125, :notes => [
            { :duration => 0.25, :pitches => [F5] },
            { :duration => 0.5, :pitches => [Eb5] }
          ]
        },
        { :offset => 2.125, :notes => [
            { :duration => 0.25, :pitches => [Eb5] },
            { :duration => 0.5, :pitches => [Eb5] }
          ]
        },
        { :offset => 3.01, :notes => [
            { :duration => 0.5, :pitches => [Eb5] },
            { :duration => 0.5, :pitches => [F5] }
          ]
        }
      ]
    }
  ]
}

score = Musicality::Score.make_from_hash score_hash
Musicality::ScoreFile.save score, "song2.yaml"

