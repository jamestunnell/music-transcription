require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::ScoreConverter do
  context '.make_time_based_parts_from_score' do
    it "should produce notes with duration appropriate to the tempo" do
      score_hash = {
        :beats_per_minute_profile => {
          :start_value => 120
        },
        :program => { :segments => [1.0...2.0] },
        :parts => [
          {
            :loudness_profile => {
              :start_value => 0.5
            },
            :note_sequences => [
              { :offset => 1.0,
                :notes => [
                  { :duration => 0.1, :pitches => [ { :octave => 9 } ] },
                  { :duration => 0.2, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                  { :duration => 0.3, :pitches => [ { :octave => 9 } ] },
                  { :duration => 0.4, :pitches => [ { :octave => 9, :semitone => 2 } ] }
                ]
              }
            ]
          }
        ],
      }
      
      score = Score.make_from_hash score_hash
      parts = ScoreConverter.make_time_based_parts_from_score score, 1000.0
      note_seq = parts.first.note_sequences.first
      
      note_seq.offset.should be_within(0.01).of(2.0)
      note_seq.notes[0].duration.should be_within(0.01).of(0.2)
      note_seq.notes[1].duration.should be_within(0.01).of(0.4)
      note_seq.notes[2].duration.should be_within(0.01).of(0.6)
      note_seq.notes[3].duration.should be_within(0.01).of(0.8)
    end
    
    it "should produce notes twice as long when tempo is half" do
      score_hash = {
        :beats_per_minute_profile => {
          :start_value => 120,
          :value_change_events => [ Event.new(1.0, 60) ]
        },
        :program => { :segments => [0.0...2.0] },
        :parts => [
          {
            :loudness_profile => {
              :start_value => 0.5
            },
            :note_sequences => [
              { :offset => 0.0,
                :notes => [
                  { :duration => 0.2, :pitches => [ { :octave => 9 } ] },
                  { :duration => 0.4, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                  { :duration => 0.2, :pitches => [ { :octave => 9 } ] },
                  { :duration => 0.1, :pitches => [ { :octave => 9, :semitone => 2 } ] }
                ]
              },
              { :offset => 1.0,
                :notes => [
                  { :duration => 0.2, :pitches => [ { :octave => 9 } ] },
                  { :duration => 0.4, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                  { :duration => 0.2, :pitches => [ { :octave => 9 } ] },
                  { :duration => 0.1, :pitches => [ { :octave => 9, :semitone => 2 } ] }
                ]
              }

            ]
          }
        ],
      }

      score = Score.make_from_hash score_hash
      parts = ScoreConverter.make_time_based_parts_from_score score, 1000.0
      
      note_seq = parts.first.note_sequences[0]
      note_seq.offset.should be_within(0.01).of(0.0)
      note_seq.notes[0].duration.should be_within(0.01).of(0.4)
      note_seq.notes[1].duration.should be_within(0.01).of(0.8)
      note_seq.notes[2].duration.should be_within(0.01).of(0.4)
      note_seq.notes[3].duration.should be_within(0.01).of(0.2)

      note_seq = parts.first.note_sequences[1]
      note_seq.offset.should be_within(0.01).of(2.0)
      note_seq.notes[0].duration.should be_within(0.01).of(0.8)
      note_seq.notes[1].duration.should be_within(0.01).of(1.6)
      note_seq.notes[2].duration.should be_within(0.01).of(0.8)
      note_seq.notes[3].duration.should be_within(0.01).of(0.4)      
    end
    
  end
end
