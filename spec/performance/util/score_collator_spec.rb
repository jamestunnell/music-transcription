require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::ScoreCollator do
  before :all do
    @simple_score_hash = {
      :beats_per_minute_profile => {
        :start_value => 120,
        :value_change_events => [ Event.new(0.5, 60, 1.0) ]
      },
      :program => { :segments => [0.0...1.0, 0.0...2.0] },
      :parts => [
        {
          :loudness_profile => {
            :start_value => 0.5,
            :value_change_events => [ Event.new(0.5, 1.0, 1.0) ]
          },
          :note_sequences => [
            { :offset => 0.0,
              :notes => [
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 1.00, :pitches => [ { :octave => 9, :semitone => 2 } ] }
              ]
            }
          ]
        }
      ],
    }
    
    @complex_score_hash = {
      :parts => [
        {
          :loudness_profile => { :start_value => 0.5 },
          :note_sequences => [
            { :offset => 0.0, :notes => [
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 1.00, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.50, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.50, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.75, :pitches => [ { :octave => 9 } ] },
              ]
            }
          ]
        }
      ],
      :beats_per_minute_profile => { :start_value => 120 },
      :program => {
        :segments => [
          0.0...2.0,
          1.0...2.0,
          1.0...2.0,
          0.0...1.0,
          2.0...3.75
        ]
      }
    }

    @two_part_score_hash = {
      :beats_per_minute_profile => { :start_value => 120 },
      :program => { :segments => [0.0...1.0, 0.0...2.0] },
      :parts => [
        {
          :loudness_profile => { :start_value => 0.5 },
          :note_sequences => [
            { :offset => 0.0,
              :notes => [
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 1.00, :pitches => [ { :octave => 9, :semitone => 2 } ] }
              ]
            }
          ]
        },
        {
          :loudness_profile => { :start_value => 0.5 },
          :note_sequences => [
            { :offset => 0.5,
              :notes => [
                { :duration => 0.5, :pitches => [ { :octave => 9 } ] },
                { :duration => 0.5, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
              ]
            }
          ]
        }
      ]
    }
  end
    
  it "should collate a simple score/program into a single segment" do
    score = Score.make_from_hash @simple_score_hash
    ScoreCollator.collate_score! score
  
    score.parts.count.should be 1
    part = score.parts.first

    #puts part.save_to_hash.to_yaml
    part.note_sequences.count.should be 2
    part.note_sequences[0].notes.count.should be 4
    part.note_sequences[1].notes.count.should be 5
    
    part.note_sequences[0].offset.should eq(0.0)
    part.note_sequences[0].duration.should eq(1.0)
    part.note_sequences[0].notes.first.duration.should eq(0.25)
    part.note_sequences[1].offset.should eq(1.0)
    part.note_sequences[1].duration.should eq(2.0)
    part.note_sequences[1].notes.last.duration.should eq(1.0)
    
    dyn_comp = Musicality::ValueComputer.new(part.loudness_profile)
    dyn_comp.value_at(0.0).should eq(0.5)
    dyn_comp.value_at(0.5).should eq(0.5)
    dyn_comp.value_at(0.99).should be_within(0.01).of(0.75)
    dyn_comp.value_at(1.0).should eq(0.5)
    dyn_comp.value_at(1.5).should eq(0.5)
    dyn_comp.value_at(2.0).should eq(0.75)
    dyn_comp.value_at(2.5).should eq(1.0)
    
    tc = Musicality::TempoComputer.new(score.beats_per_minute_profile, score.beat_duration_profile)
    tc.notes_per_second_at(0.0).should eq(0.5)
    tc.notes_per_second_at(0.5).should eq(0.5)
    tc.notes_per_second_at(0.75).should be_within(0.01).of(0.4375)
    tc.notes_per_second_at(0.999).should be_within(0.01).of(0.375)
    tc.notes_per_second_at(1.0).should be_within(0.01).of(0.5)
    tc.notes_per_second_at(1.5).should be_within(0.01).of(0.5)
    tc.notes_per_second_at(2.0).should be_within(0.01).of(0.375)
    tc.notes_per_second_at(2.5).should be_within(0.01).of(0.25)
  end

  it "should handle a complex one-part score" do
    score = Score.make_from_hash @complex_score_hash
    ScoreCollator.collate_score! score

    score.find_start.should be_within(0.01).of(0.0)
    score.find_end.should be_within(0.01).of(6.75)

    parts = score.parts
    parts.count.should be 1
    part = parts.first

    #puts part.save_to_hash.to_yaml
    part.note_sequences.count.should eq(5)
    part.note_sequences[0].notes.count.should eq(5)
    part.note_sequences[1].notes.count.should eq(1)
    part.note_sequences[2].notes.count.should eq(1)
    part.note_sequences[3].notes.count.should eq(4)
    part.note_sequences[4].notes.count.should eq(3)
    
    part.note_sequences[0].offset.should be_within(0.01).of(0.0)
    part.note_sequences[1].offset.should be_within(0.01).of(2.0)
    part.note_sequences[2].offset.should be_within(0.01).of(3.0)
    part.note_sequences[3].offset.should be_within(0.01).of(4.0)
    part.note_sequences[4].offset.should be_within(0.01).of(5.0)
    
    part.note_sequences[0].duration.should be_within(0.01).of(2.0)
    part.note_sequences[0].notes.first.duration.should be_within(0.01).of(0.25)
    part.note_sequences[0].notes.last.duration.should be_within(0.01).of(1.0)
    
    part.note_sequences[1].duration.should be_within(0.01).of(1.0)
    part.note_sequences[1].notes.first.duration.should be_within(0.01).of(1.0)
    part.note_sequences[1].notes.last.duration.should be_within(0.01).of(1.0)
    
    part.note_sequences[2].duration.should be_within(0.01).of(1.0)
    part.note_sequences[2].notes.first.duration.should be_within(0.01).of(1.0)
    part.note_sequences[2].notes.last.duration.should be_within(0.01).of(1.0)
    
    part.note_sequences[3].duration.should be_within(0.01).of(1.0)
    part.note_sequences[3].notes.first.duration.should be_within(0.01).of(0.25)
    part.note_sequences[3].notes.last.duration.should be_within(0.01).of(0.25)
    
    part.note_sequences[4].duration.should be_within(0.01).of(1.75)
    part.note_sequences[4].notes.first.duration.should be_within(0.01).of(0.5)
    part.note_sequences[4].notes.last.duration.should be_within(0.01).of(0.75)
  end

  it "should handle a simple two-part score" do
    score = Score.make_from_hash @two_part_score_hash
    ScoreCollator.collate_score! score

    score.find_start.should be_within(0.01).of(0.0)
    score.find_end.should be_within(0.01).of(3.0)

    parts = score.parts
    parts.count.should be 2
    part0 = parts[0]
    part1 = parts[1]

    part0.note_sequences.count.should be 2
    part0.note_sequences[0].notes.count.should be 4
    part0.note_sequences[1].notes.count.should be 5
    
    part0.note_sequences[0].offset.should be_within(0.01).of(0.0)
    part0.note_sequences[0].duration.should be_within(0.01).of(1.0)
    part0.note_sequences[0].notes.first.duration.should be_within(0.01).of(0.25)
    part0.note_sequences[1].offset.should be_within(0.01).of(1.0)
    part0.note_sequences[1].duration.should be_within(0.01).of(2.0)
    part0.note_sequences[1].notes.last.duration.should be_within(0.01).of(1.0)

    part1.note_sequences.count.should be 2
    part1.note_sequences[0].notes.count.should be 1
    part1.note_sequences[1].notes.count.should be 4
    
    part1.note_sequences[0].offset.should be_within(0.01).of(0.5)
    part1.note_sequences[0].duration.should be_within(0.01).of(0.5)
    part1.note_sequences[0].notes.first.duration.should be_within(0.01).of(0.5)
    part1.note_sequences[1].offset.should be_within(0.01).of(1.5)
    part1.note_sequences[1].duration.should be_within(0.01).of(1.5)
    part1.note_sequences[1].notes.last.duration.should be_within(0.01).of(0.25)
  end

end
