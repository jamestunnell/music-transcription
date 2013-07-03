require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Conductor do

  before :all do
    @score = TempoScore.new(
      :parts => {
        1 => Part.new(
          :loudness => { :start_value => 0.5 },
          :notes => [
            Note.new( :duration => 0.05, :intervals => [ Interval.new(:pitch => "C9".to_pitch) ] ),
            Note.new( :duration => 0.05, :intervals => [ Interval.new(:pitch => "D9".to_pitch) ] ),
            Note.new( :duration => 0.05, :intervals => [ Interval.new(:pitch => "E9".to_pitch) ] ),
            Note.new( :duration => 0.05, :intervals => [ Interval.new(:pitch => "C9".to_pitch) ] ),
            Note.new( :duration => 0.05, :intervals => [ Interval.new(:pitch => "D9".to_pitch) ] ),
            Note.new( :duration => 0.05, :intervals => [ Interval.new(:pitch => "E9".to_pitch) ] ),
          ]
        )
      },
      :tempo_profile => Profile.new( :start_value => tempo(360) ),
      :program => Program.new(
        :segments => [
          0.0...2.0,
          1.0...2.0,
          1.0...2.0,
          0.0...1.0,
          2.0...3.75
        ]
      )
    )
    
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
      notes_per_sec = @score.tempo_profile.start_value.notes_per_second
      score_length_notes = @score.program.length
      score_length_sec = score_length_notes / notes_per_sec
      score_length_samples = score_length_sec * @sample_rate

      @conductor.time_counter.should be_within(0.01).of(score_length_sec)
      @conductor.sample_counter.should be_within(10).of(score_length_samples)
    end
    
    context 'score with no tempo_profile' do
    end
  end

end
