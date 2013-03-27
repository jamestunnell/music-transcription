require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::ScoreCollator do
  before :all do
    @simple_score_hash = {
      :beats_per_minute_profile => {
        :start_value => 120,
        :value_change_events => [ Event.new(0.5, 60, 1.0) ]
      },
      :program => { :segments => [0.0...1.0, 0.0...2.0] },
      :parts => {
        "1" => {
          :start_offset => 0.0,
          :loudness_profile => {
            :start_value => 0.5,
            :value_change_events => [ Event.new(0.5, 1.0, 1.0) ]
          },
          :note_groups => [
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 1.00, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
          ]
        }
      },
    }
    
    @complex_score_hash = {
      :parts => {
        :part1 => {
          :start_offset => 0.0,
          :loudness_profile => { :start_value => 0.5 },
          :note_groups => [
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 1.00, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.50, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.50, :notes => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.75, :notes => [ {:pitch => { :octave => 9 }} ] },
          ]
        }
      },
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
      :parts => {
        :a => {
          :loudness_profile => { :start_value => 0.5 },
          :note_groups => [
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 1.00, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
          ]
        },
        :b => {
          :loudness_profile => { :start_value => 0.5 },
          :note_groups => [
            { :duration => 0.50, :notes => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.50, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.25, :notes => [ {:pitch => { :octave => 9 }} ] },
          ]
        }
      }
    }
  end
    
  it "should collate a simple score/program into a single segment" do
    score = Score.new @simple_score_hash
    ScoreCollator.collate_score! score
  
    score.parts.count.should eq 1
    part = score.parts.values.first

    group_durations = [0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,1.0]
    part.note_groups.count.should eq(group_durations.count)
    part.note_groups.each_index do |i|
      part.note_groups[i].duration.should eq(group_durations [i])
    end

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
    score = Score.new @complex_score_hash
    ScoreCollator.collate_score! score

    score.find_start.should be_within(0.01).of(0.0)
    score.find_end.should be_within(0.01).of(6.75)

    parts = score.parts.values
    parts.count.should eq 1
    part = parts.first

    group_durations = [0.25,0.25,0.25,0.25,1.0,1.0,1.0,0.25,0.25,0.25,0.25,0.5,0.5,0.75]
    part.note_groups.count.should eq(group_durations.count)
    part.note_groups.each_index do |i|
      part.note_groups[i].duration.should eq(group_durations [i])
    end
  end

  it "should handle a simple two-part score" do
    score = Score.new @two_part_score_hash
    ScoreCollator.collate_score! score

    score.find_start.should be_within(0.01).of(0.0)
    score.find_end.should be_within(0.01).of(3.0)

    parts = score.parts.values
    parts.count.should eq 2
    part0 = parts[0]
    part1 = parts[1]

    part0_group_durations = [0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,1.0]
    part0.note_groups.count.should eq part0_group_durations.count
    part0.note_groups.each_index do |i|
      part0.note_groups[i].duration.should eq(part0_group_durations[i])
    end
    
    part1_group_durations = [0.5,0.5,0.5,0.5,0.25,0.25]
    part1.note_groups.count.should eq part1_group_durations.count
    part1.note_groups.each_index do |i|
      part1.note_groups[i].duration.should eq(part1_group_durations[i])
    end
  end

end
