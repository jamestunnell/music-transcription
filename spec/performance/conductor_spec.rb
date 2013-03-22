require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Conductor do

  before :all do
    hash = {
      :parts => {
        1 => {
          :loudness_profile => { :start_value => 0.5 },
          :note_sequences => [
            { :offset => 0.0, :notes => [
                { :duration => 0.05, :pitch => { :octave => 9 } },
                { :duration => 0.05, :pitch => { :octave => 9, :semitone => 2 } },
                { :duration => 0.05, :pitch => { :octave => 9, :semitone => 4 } },
                { :duration => 0.05, :pitch => { :octave => 9 } },
                { :duration => 0.05, :pitch => { :octave => 9, :semitone => 2 } },
                { :duration => 0.05, :pitch => { :octave => 9, :semitone => 4 } },
              ]
            }
          ]
        }
      },
      :beats_per_minute_profile => { 
        :start_value => 360
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
    
    @score = Score.new hash
    @sample_rate = 250.0
  end

  describe "#perform_score" do
    before :each do
      time_conversion_rate = 250.0
      @conductor = Musicality::Conductor.new @score, time_conversion_rate, @sample_rate
      @conductor.perform
    end

    it "should be able to perform the entire score" do
      #how long it should take time-wise
      notes_per_sec = @score.beats_per_minute_profile.start_value * @score.beat_duration_profile.start_value / 60.0
      score_length_notes = @score.program.length
      score_length_sec = score_length_notes / notes_per_sec
      score_length_samples = score_length_sec * @sample_rate

      @conductor.time_counter.should be_within(0.01).of(score_length_sec)
      @conductor.sample_counter.should be_within(10).of(score_length_samples)
    end
  end

end
