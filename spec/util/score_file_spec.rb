require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'yaml'

describe Musicality::ScoreFile do
  before :all do 
    @score_hash = {
      :beats_per_minute_profile => {
        :start_value => 300,
        :value_changes => [ value_change(1.0, 100, linear(1.25)) ]
      },
      :program => { :segments => [0.0...3.75] },
      :parts => {
        "1" => {
          :notes => [
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },            
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.25, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.75, :intervals => [ {:pitch => { :octave => 9 }} ] },
          ],
        }
      }

    }
    @score = Score.new @score_hash
    @score_filename = "score_file_spec.yaml"
  end
  
  it "should produce the same Score object after a save/load" do
    ScoreFile.save @score, @score_filename
    score = ScoreFile.load @score_filename
    @score.should eq(score)
  end
    
  after :all do
    File.delete @score_filename
  end
end

