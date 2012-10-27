require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'yaml'

describe Musicality::ScoreFile do
  before :all do 
    @score_hash = {
      :parts => [
        :notes => [
          { :offset => 0.00, :duration => 0.25, :pitch => { :octave => 9 } },
          { :offset => 0.25, :duration => 0.25, :pitch => { :octave => 9, :semitone => 2 } },
          { :offset => 0.50, :duration => 0.25, :pitch => { :octave => 9, :semitone => 4 } },
          { :offset => 0.75, :duration => 0.25, :pitch => { :octave => 9 } },
          { :offset => 1.00, :duration => 0.25, :pitch => { :octave => 9, :semitone => 2 } },
          { :offset => 1.25, :duration => 0.25, :pitch => { :octave => 9, :semitone => 4 } },
          { :offset => 1.50, :duration => 0.25, :pitch => { :octave => 9 } },
          { :offset => 1.75, :duration => 0.25, :pitch => { :octave => 9, :semitone => 2 } },
          { :offset => 2.00, :duration => 0.25, :pitch => { :octave => 9, :semitone => 4 } },
          { :offset => 2.25, :duration => 0.25, :pitch => { :octave => 9 } },
          { :offset => 2.50, :duration => 0.25, :pitch => { :octave => 9, :semitone => 2 } },
          { :offset => 2.75, :duration => 0.25, :pitch => { :octave => 9, :semitone => 4 } },
          { :offset => 3.00, :duration => 0.75, :pitch => { :octave => 9 } },
        ]
      ],
      :tempos => [
        { :offset => 0.0, :duration => 0.0, :beats_per_minute => 300, :beat_duration => 0.25 },
        { :offset => 1.0, :duration => 1.25, :beats_per_minute => 100, :beat_duration => 0.25 }
      ]
    }
    
    @score_hash_filename = "score_hash.yaml"
    File.new @score_hash_filename, "w"  #create a writeable file
    File.open @score_hash_filename, "w" do |file|
      file.write @score_hash.to_yaml
    end
  end
  
  it "should load score from file" do
    score = ScoreFile.load @score_hash_filename
    score.class.should eq(Score)
    score.parts.count.should be 1
    score.tempos.count.should be 2
  end
end

