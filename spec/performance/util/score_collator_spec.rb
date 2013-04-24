require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::ScoreCollator do
  before :all do
    @simple_score_hash = {
      :beats_per_minute_profile => {
        :start_value => 120,
        :value_changes => { 0.5 => Musicality::linear_change(60,1.0) }
      },
      :program => { :segments => [0.0...1.0, 0.0...2.0] },
      :parts => {
        "1" => {
          :start_offset => 0.0,
          :loudness_profile => {
            :start_value => 0.5,
            :value_changes => { 0.5 => Musicality::linear_change(1.0,1.0) }
          },
          :notes => [
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 1.00, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
          ]
        }
      },
    }
    
    @complex_score_hash = {
      :parts => {
        :part1 => {
          :start_offset => 0.0,
          :loudness_profile => { :start_value => 0.5 },
          :notes => [
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 1.00, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.50, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.50, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.75, :intervals => [ {:pitch => { :octave => 9 }} ] },
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
          :notes => [
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 1.00, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
          ]
        },
        :b => {
          :loudness_profile => { :start_value => 0.5 },
          :notes => [
            { :duration => 0.50, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.50, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
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

    durations = [0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,1.0]
    part.notes.count.should eq(durations.count)
    part.notes.each_index do |i|
      part.notes[i].duration.should eq(durations [i])
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

    durations = [0.25,0.25,0.25,0.25,1.0,1.0,1.0,0.25,0.25,0.25,0.25,0.5,0.5,0.75]
    part.notes.count.should eq(durations.count)
    part.notes.each_index do |i|
      part.notes[i].duration.should eq(durations [i])
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

    part0_durations = [0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25,1.0]
    part0.notes.count.should eq part0_durations.count
    part0.notes.each_index do |i|
      part0.notes[i].duration.should eq(part0_durations[i])
    end
    
    part1_durations = [0.5,0.5,0.5,0.5,0.25,0.25,0.5]
    part1.notes.count.should eq part1_durations.count
    part1.notes.each_index do |i|
      part1.notes[i].duration.should eq(part1_durations[i])
    end
  end

end
