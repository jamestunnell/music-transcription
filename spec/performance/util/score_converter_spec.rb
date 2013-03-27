require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::ScoreConverter do
  context '.make_time_based_parts_from_score' do
    it "should produce notes with duration appropriate to the tempo" do
      score_hash = {
        :beats_per_minute_profile => {
          :start_value => 120
        },
        :program => { :segments => [1.0...2.0] },
        :parts => {
          1 => {
            :start_offset => 1.0,
            :loudness_profile => {
              :start_value => 0.5
            },
            :note_groups => [
              { :duration => 0.1, :notes => [ {:pitch => { :octave => 9 }} ] },
              { :duration => 0.2, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
              { :duration => 0.3, :notes => [ {:pitch => { :octave => 9 }} ] },
              { :duration => 0.4, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            ]
          }
        },
      }
      
      score = Score.new score_hash
      parts = ScoreConverter.make_time_based_parts_from_score score, 1000.0
      part = parts.values.first
      
      part.start_offset.should be_within(0.01).of(2.0)
      part.note_groups[0].duration.should be_within(0.01).of(0.2)
      part.note_groups[1].duration.should be_within(0.01).of(0.4)
      part.note_groups[2].duration.should be_within(0.01).of(0.6)
      part.note_groups[3].duration.should be_within(0.01).of(0.8)
    end
    
    it "should produce notes twice as long when tempo is half" do
      score_hash = {
        :beats_per_minute_profile => {
          :start_value => 120,
          :value_change_events => [ Event.new(1.0, 60) ]
        },
        :program => { :segments => [0.0...2.0] },
        :parts => {
          1 => {
            :start_offset => 0.0,
            :loudness_profile => {
              :start_value => 0.5
            },
            :note_groups => [
              { :duration => 0.2, :notes => [ {:pitch => { :octave => 9 }} ] },
              { :duration => 0.4, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
              { :duration => 0.3, :notes => [ {:pitch => { :octave => 9 }} ] },
              { :duration => 0.1, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },

              { :duration => 0.2, :notes => [ {:pitch => { :octave => 9 }} ] },
              { :duration => 0.4, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
              { :duration => 0.3, :notes => [ {:pitch => { :octave => 9 }} ] },
              { :duration => 0.1, :notes => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            ]
          }
        },
      }
    
      score = Score.new score_hash
      parts = ScoreConverter.make_time_based_parts_from_score score, 1000.0
      part = parts.values.first
      
      part.start_offset.should be_within(0.01).of(0.0)
      
      part.note_groups[0].duration.should be_within(0.01).of(0.4)
      part.note_groups[1].duration.should be_within(0.01).of(0.8)
      part.note_groups[2].duration.should be_within(0.01).of(0.6)
      part.note_groups[3].duration.should be_within(0.01).of(0.2)
      
      part.note_groups[4].duration.should be_within(0.01).of(0.8)
      part.note_groups[5].duration.should be_within(0.01).of(1.6)
      part.note_groups[6].duration.should be_within(0.01).of(1.2)
      part.note_groups[7].duration.should be_within(0.01).of(0.4)      
    end
    
  end
end
