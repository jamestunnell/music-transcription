require 'musicality'

C3 = Musicality::PitchConstants::C3
D3 = Musicality::PitchConstants::D3
E3 = Musicality::PitchConstants::E3
F3 = Musicality::PitchConstants::F3

score_hash = {
  :program => {
    :segments => [0...4.0]
  },
  :beats_per_minute_profile => { :start_value => 120.0 },
  :parts => {
    1 => {
      :loudness_profile => { :start_value => 0.5 },
      :note_sequences => [
        { :offset => 0.0, :notes => [
            { :duration => 0.25, :pitch => C3 },
            { :duration => 0.25, :pitch => D3 },
            { :duration => 0.25, :pitch => E3 },
            { :duration => 0.25, :pitch => F3 },
            { :duration => 0.25, :pitch => E3 },
            { :duration => 0.25, :pitch => D3 },
            { :duration => 0.5, :pitch => C3 }
          ]
        },
        { :offset => 2.0, :notes => [
            { :duration => 0.25, :pitch => C3, :relationship => Musicality::Note::RELATIONSHIP_LEGATO },
            { :duration => 0.25, :pitch => D3, :relationship => Musicality::Note::RELATIONSHIP_LEGATO },
            { :duration => 0.25, :pitch => E3, :relationship => Musicality::Note::RELATIONSHIP_LEGATO },
            { :duration => 0.25, :pitch => F3, :relationship => Musicality::Note::RELATIONSHIP_LEGATO },
            { :duration => 0.25, :pitch => E3, :relationship => Musicality::Note::RELATIONSHIP_LEGATO },
            { :duration => 0.25, :pitch => D3, :relationship => Musicality::Note::RELATIONSHIP_LEGATO },
            { :duration => 0.5, :pitch => C3 }
          ]
        }

      ]
    }
  }
}

score = Musicality::Score.make_from_hash score_hash
Musicality::ScoreFile.save score, "legato_test.yml"

