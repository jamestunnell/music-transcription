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
  :parts => [
    {
      :loudness_profile => { :start_value => 0.5 },
      :note_sequences => [
        { :offset => 0.0, :notes => [
            { :duration => 0.75, :pitch => C3, :relationship => Musicality::Note::RELATIONSHIP_PORTAMENTO },
            { :duration => 0.75, :pitch => F3, :relationship => Musicality::Note::RELATIONSHIP_PORTAMENTO },
            { :duration => 0.5, :pitch => C3 }
          ]
        }
      ],
      :id => "1"
    }
  ]
}

score = Musicality::Score.make_from_hash score_hash
Musicality::ScoreFile.save score, "portamento_test.yml"

