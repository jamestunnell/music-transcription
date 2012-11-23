require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'yaml'

describe Musicality::ScoreFile do
  before :all do 
    @score_hash = {
      :beats_per_minute_profile => {
        :start_value => 300,
        :value_change_events => [ Event.new(1.0, 100, 1.25) ]
      },
      :program => { :segments => [0.0...3.75] },
      :parts => [
        {
          :sequences => [
            { :offset => 0.0, :notes => [
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 2 } ] },
                { :duration => 0.25, :pitches => [ { :octave => 9, :semitone => 4 } ] },
                { :duration => 0.75, :pitches => [ { :octave => 9 } ] },
              ]
            }
          ],
          :id=> "1",
        }
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
    score.beats_per_minute_profile.value_change_events.count.should be 1
  end
  
  it "should save score to file" do
    score = ScoreFile.load @score_hash_filename
    
    mod_filename = "x_" + @score_hash_filename
    ScoreFile.save score, mod_filename
    
    f1 = File.open @score_hash_filename, "r"
    f2 = File.open mod_filename, "r"
    
    f1.size.should eq(f2.size)
    s1 = f1.read
    s2 = f2.read
    s1.should eq(s2)
  end
  
  after :all do
    #File.delete @score_hash_filename
    #File.delete "x_" + @score_hash_filename
  end
end

