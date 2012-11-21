require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'yaml'

describe Musicality::ScoreFile do
  before :all do 
    @score_hash = {
      :start_tempo => { :beats_per_minute => 300, :beat_duration => 0.25, :offset => 0.0 },
      :program => { :segments => [0.0...3.75] },
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
      ],
      :tempo_changes => [
        { :beats_per_minute => 100, :beat_duration => 0.25, :offset => 1.0, :duration => 1.25 }
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
    score.tempo_changes.count.should be 1
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
    File.delete @score_hash_filename
    File.delete "x_" + @score_hash_filename
  end
end

