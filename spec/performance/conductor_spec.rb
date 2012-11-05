require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Conductor do

  before :each do
    hash = {
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
          ]
        }
      ],
      :tempos => [
        { :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0 }
      ],
      :program => {
        :start => 0.0,
        :stop => 3.75,
        :markers => { :a => 1.0, :b => 2.0 },
        :jumps => [
          { :at => :b, :to => :a },
          { :at => :b, :to => :a },
          { :at => :b, :to => 0.0 },
          { :at => :a, :to => :b },
        ]
      }
    }
    
    @score = Musicality::HashMake.make_from_hash Musicality::Score, hash
    @sample_rate = 48.0
  end
  
  it "should follow the given score program" do    
    conductor = Musicality::Conductor.new @score, @sample_rate
    
    conductor.prepare_performance_at 0.0
    while conductor.jumps_left.any? || (conductor.note_current <= conductor.score.program.stop)
      conductor.perform_sample
    end
    
    #how long it should take
    notes_per_sec = 0.5
    score_length_notes = 6.75
    score_length_sec = score_length_notes / notes_per_sec
    score_length_samples = score_length_sec * @sample_rate
    
    #compare to how long it did take
    conductor.sample_total.should be_within(2).of(score_length_samples)
  end

end
