require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Score do
  it "should collate a simple score/program into a single segment" do
    score = TempoScore.new(
      :tempo_profile => profile(tempo(120), 0.5 => Musicality::linear_change(tempo(60),1.0)),
      :program => Program.new( :segments => [0.0...1.0, 0.0...2.0] ),
      :parts => {
        "1" => Part.new(
          :loudness_profile => profile(0.5, 0.5 => Musicality::linear_change(1.0,1.0)),
          :notes => [
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "E9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
            Note.new( :duration => 1.00, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
          ]
        )
      },
    )
    score.collate!
  
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
    
    tc = Musicality::TempoComputer.new(score.tempo_profile)
    tc.value_at(0.0).should eq(tempo(120))
    tc.value_at(0.5).should eq(tempo(120))
    tc.value_at(0.75).should eq(tempo(105))
    tc.notes_per_second_at(0.99999).should be_within(0.1).of(0.375)
    tc.value_at(1.0).should eq(tempo(120))
    tc.value_at(1.5).should eq(tempo(120))
    tc.value_at(1.75).should eq(tempo(105))
    tc.value_at(2.0).should eq(tempo(90))
    tc.value_at(2.25).should eq(tempo(75))
    tc.value_at(2.5).should eq(tempo(60))
  end

  it "should handle a complex one-part score" do
    score = TempoScore.new(
      :parts => {
        :part1 => Part.new(
          :loudness_profile => profile(0.5),
          :notes => [
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "E9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
            Note.new( :duration => 1.00, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
            Note.new( :duration => 0.5, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
            Note.new( :duration => 0.5, :intervals => [ Interval.new( :pitch => "E9".to_pitch ) ] ),
            Note.new( :duration => 0.75, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
          ]
        )
      },
      :tempo_profile => profile(tempo(120)),
      :program => Program.new(
        :segments => [
          0.0...2.0,
          1.0...2.0,
          1.0...2.0,
          0.0...1.0,
          2.0...3.75
        ]
      )
    )
    score.collate!

    score.start.should be_within(0.01).of(0.0)
    score.end.should be_within(0.01).of(6.75)

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
    score = TempoScore.new(
      :tempo_profile => profile(tempo(120)),
      :program => Program.new( :segments => [0.0...1.0, 0.0...2.0] ),
      :parts => {
        :a => Part.new(
          :loudness_profile => profile(0.5),
          :notes => [
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "E9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
            Note.new( :duration => 1.00, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
          ]
        ),
        :b => Part.new(
          :loudness_profile => profile(0.5),
          :notes => [
            Note.new( :duration => 0.5, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
            Note.new( :duration => 0.5, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "E9".to_pitch ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
          ]
        )
      }
    )
    score.collate!

    score.start.should be_within(0.01).of(0.0)
    score.end.should be_within(0.01).of(3.0)

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
