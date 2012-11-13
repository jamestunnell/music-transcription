require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Conductor do

  before :each do
    hash = {
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
          ]
        }
      ],
      :start_tempo => { 
        :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0 
      },
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
    
    @score = Score.make_from_hash hash
    @sample_rate = 1000.0
  end

  describe "#perform_score" do
    before :each do
      @conductor = Musicality::Conductor.new @score, @sample_rate
      @conductor.perform_score
    end

    it "should be able to perform the entire score" do
      #how long it should take time-wise
      notes_per_sec = 0.5
      score_length_notes = @score.program.length
      score_length_sec = score_length_notes / notes_per_sec
      score_length_samples = score_length_sec * @sample_rate

      @conductor.time_counter.should be_within(0.001).of(score_length_sec)
      @conductor.sample_counter.should be_within(10).of(score_length_samples)
    end
  end

end
