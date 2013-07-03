require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Score do
  context '.make_time_based_parts_from_score' do
    it "should produce notes with duration appropriate to the tempo" do
      score = TempoScore.new(
        :tempo_profile => profile(tempo(120)),
        :program => Program.new(:segments => [1.0...2.0]),
        :parts => {
          1 => Part.new(
            :offset => 1.0,
            :loudness_profile => profile(0.5),
            :notes => [
              Note.new( :duration => 0.1, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
              Note.new( :duration => 0.2, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
              Note.new( :duration => 0.3, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
              Note.new( :duration => 0.4 , :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
            ]
          )
        },
      )
      score = score.convert_to_time_base 1000.0
      part = score.parts.values.first
      
      part.offset.should be_within(0.01).of(2.0)
      part.notes[0].duration.should be_within(0.01).of(0.2)
      part.notes[1].duration.should be_within(0.01).of(0.4)
      part.notes[2].duration.should be_within(0.01).of(0.6)
      part.notes[3].duration.should be_within(0.01).of(0.8)
    end
    
    it "should produce notes twice as long when tempo is half" do
      score = TempoScore.new(
        :tempo_profile => profile(tempo(120), 1.0 => Musicality::immediate_change(tempo(60)) ),
        :program => Program.new( :segments => [0.0...2.0] ),
        :parts => {
          1 => Part.new(
            :offset => 0.0,
            :loudness_profile => profile(0.5),
            :notes => [
              Note.new( :duration => 0.2, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
              Note.new( :duration => 0.4, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
              Note.new( :duration => 0.3, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
              Note.new( :duration => 0.1 , :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
              
              Note.new( :duration => 0.2, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
              Note.new( :duration => 0.4, :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
              Note.new( :duration => 0.3, :intervals => [ Interval.new( :pitch => "C9".to_pitch ) ] ),
              Note.new( :duration => 0.1 , :intervals => [ Interval.new( :pitch => "D9".to_pitch ) ] ),
            ]
          )
        },
      )
      score = score.convert_to_time_base 1000.0
      part = score.parts.values.first
      
      part.offset.should be_within(0.01).of(0.0)
      
      part.notes[0].duration.should be_within(0.01).of(0.4)
      part.notes[1].duration.should be_within(0.01).of(0.8)
      part.notes[2].duration.should be_within(0.01).of(0.6)
      part.notes[3].duration.should be_within(0.01).of(0.2)
      
      part.notes[4].duration.should be_within(0.01).of(0.8)
      part.notes[5].duration.should be_within(0.01).of(1.6)
      part.notes[6].duration.should be_within(0.01).of(1.2)
      part.notes[7].duration.should be_within(0.01).of(0.4)      
    end
  end
end
