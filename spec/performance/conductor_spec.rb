require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Conductor do

  before :all do
    hash = {
      :parts => {
        1 => {
          :start_offset => 0,
          :loudness => { :start_value => 0.5 },
          :notes => [
            { :duration => 0.05, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.05, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.05, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
            { :duration => 0.05, :intervals => [ {:pitch => { :octave => 9 }} ] },
            { :duration => 0.05, :intervals => [ {:pitch => { :octave => 9, :semitone => 2 }} ] },
            { :duration => 0.05, :intervals => [ {:pitch => { :octave => 9, :semitone => 4 }} ] },
          ]
        }
      },
      :beats_per_minute_profile => { :start_value => 360 },
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
    @arrangement = Arrangement.new(:score => @score)
    @sample_rate = 250
  end

  describe "#perform" do
    before :each do
      time_conversion_rate = 250
      @conductor = Musicality::Conductor.new(
        :arrangement => @arrangement,
        :time_conversion_sample_rate => time_conversion_rate,
        :rendering_sample_rate => @sample_rate,
      )
      @conductor.perform
    end

    it "should be able to perform the entire score" do
      #how long it should take time-wise
      notes_per_sec = (@score.beats_per_minute_profile.start_value / 60.0) * @score.beat_duration_profile.start_value
      score_length_notes = @score.program.length
      score_length_sec = score_length_notes / notes_per_sec
      score_length_samples = score_length_sec * @sample_rate

      @conductor.time_counter.should be_within(0.01).of(score_length_sec)
      @conductor.sample_counter.should be_within(10).of(score_length_samples)
    end
  end

end
