require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::ScoreCollator do
  before :all do
    @simple_score_hash = {
      :start_tempo => { :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0 },
      :program => { :segments => [0.0...1.0, 0.0...2.0] },
      :parts => [
        {
          :start_dynamic => {
            :offset => 0.0,
            :loudness => 0.5
          },
          :sequences => [
            { :offset => 0.0,
              :notes => [
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 1.00, :pitches => [ { :octave => 9, :semitone => 2 } ] }
              ]
            }
          ],
          :dynamic_changes => [
            { :loudness => 1.0, :offset => 0.5, :duration => 1.0 }
          ]
        }
      ],
      :tempo_changes => [
        { :beats_per_minute => 60.0, :beat_duration => 0.25, :offset => 0.5, :duration => 1.0 }
      ]
    }
    
    @complex_score_hash = {
      :parts => [
        {
          :start_dynamic => {
            :offset => 0.0,
            :loudness => 0.5
          },
          :sequences => [
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
      :start_tempo => { 
        :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0 
      },
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
      :start_tempo => { :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0 },
      :program => { :segments => [0.0...1.0, 0.0...2.0] },
      :parts => [
        {
          :start_dynamic => {
            :offset => 0.0,
            :loudness => 0.5
          },
          :sequences => [
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
          :start_dynamic => {
            :offset => 0.0,
            :loudness => 0.5
          },
          :sequences => [
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
      ],
      :tempo_changes => [ ]
    }
  end
    
  it "should collate a simple score/program into a single segment" do
    score = Score.make_from_hash @simple_score_hash
    ScoreCollator.collate_score score
  
    score.parts.count.should be 1
    part = score.parts.first

    #puts part.save_to_hash.to_yaml
    part.sequences.count.should be 2
    part.sequences[0].notes.count.should be 4
    part.sequences[1].notes.count.should be 5
    
    part.sequences[0].offset.should eq(0.0)
    part.sequences[0].duration.should eq(1.0)
    part.sequences[0].notes.first.duration.should eq(0.25)
    part.sequences[1].offset.should eq(1.0)
    part.sequences[1].duration.should eq(2.0)
    part.sequences[1].notes.last.duration.should eq(1.0)
    
    dyn_comp = Musicality::DynamicComputer.new(part.start_dynamic, part.dynamic_changes)
    dyn_comp.loudness_at(0.0).should eq(0.5)
    dyn_comp.loudness_at(0.5).should eq(0.5)
    dyn_comp.loudness_at(0.99).should be_within(0.01).of(0.75)
    dyn_comp.loudness_at(1.0).should eq(0.5)
    dyn_comp.loudness_at(1.5).should eq(0.5)
    dyn_comp.loudness_at(2.0).should eq(0.75)
    dyn_comp.loudness_at(2.5).should eq(1.0)
    
    tc = Musicality::TempoComputer.new(score.start_tempo, score.tempo_changes)
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
    ScoreCollator.collate_score score

    score.find_start.should be_within(0.01).of(0.0)
    score.find_end.should be_within(0.01).of(6.75)

    parts = score.parts
    parts.count.should be 1
    part = parts.first

    #puts part.save_to_hash.to_yaml
    part.sequences.count.should eq(5)
    part.sequences[0].notes.count.should eq(5)
    part.sequences[1].notes.count.should eq(1)
    part.sequences[2].notes.count.should eq(1)
    part.sequences[3].notes.count.should eq(4)
    part.sequences[4].notes.count.should eq(3)
    
    part.sequences[0].offset.should be_within(0.01).of(0.0)
    part.sequences[1].offset.should be_within(0.01).of(2.0)
    part.sequences[2].offset.should be_within(0.01).of(3.0)
    part.sequences[3].offset.should be_within(0.01).of(4.0)
    part.sequences[4].offset.should be_within(0.01).of(5.0)
    
    part.sequences[0].duration.should be_within(0.01).of(2.0)
    part.sequences[0].notes.first.duration.should be_within(0.01).of(0.25)
    part.sequences[0].notes.last.duration.should be_within(0.01).of(1.0)
    
    part.sequences[1].duration.should be_within(0.01).of(1.0)
    part.sequences[1].notes.first.duration.should be_within(0.01).of(1.0)
    part.sequences[1].notes.last.duration.should be_within(0.01).of(1.0)
    
    part.sequences[2].duration.should be_within(0.01).of(1.0)
    part.sequences[2].notes.first.duration.should be_within(0.01).of(1.0)
    part.sequences[2].notes.last.duration.should be_within(0.01).of(1.0)
    
    part.sequences[3].duration.should be_within(0.01).of(1.0)
    part.sequences[3].notes.first.duration.should be_within(0.01).of(0.25)
    part.sequences[3].notes.last.duration.should be_within(0.01).of(0.25)
    
    part.sequences[4].duration.should be_within(0.01).of(1.75)
    part.sequences[4].notes.first.duration.should be_within(0.01).of(0.5)
    part.sequences[4].notes.last.duration.should be_within(0.01).of(0.75)
  end

  it "should handle a simple two-part score" do
    score = Score.make_from_hash @two_part_score_hash
    ScoreCollator.collate_score score

    score.find_start.should be_within(0.01).of(0.0)
    score.find_end.should be_within(0.01).of(3.0)

    parts = score.parts
    parts.count.should be 2
    part0 = parts[0]
    part1 = parts[1]

    part0.sequences.count.should be 2
    part0.sequences[0].notes.count.should be 4
    part0.sequences[1].notes.count.should be 5
    
    part0.sequences[0].offset.should be_within(0.01).of(0.0)
    part0.sequences[0].duration.should be_within(0.01).of(1.0)
    part0.sequences[0].notes.first.duration.should be_within(0.01).of(0.25)
    part0.sequences[1].offset.should be_within(0.01).of(1.0)
    part0.sequences[1].duration.should be_within(0.01).of(2.0)
    part0.sequences[1].notes.last.duration.should be_within(0.01).of(1.0)

    part1.sequences.count.should be 2
    part1.sequences[0].notes.count.should be 1
    part1.sequences[1].notes.count.should be 4
    
    part1.sequences[0].offset.should be_within(0.01).of(0.5)
    part1.sequences[0].duration.should be_within(0.01).of(0.5)
    part1.sequences[0].notes.first.duration.should be_within(0.01).of(0.5)
    part1.sequences[1].offset.should be_within(0.01).of(1.5)
    part1.sequences[1].duration.should be_within(0.01).of(1.5)
    part1.sequences[1].notes.last.duration.should be_within(0.01).of(0.25)
  end

end
