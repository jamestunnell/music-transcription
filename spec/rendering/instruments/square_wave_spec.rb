require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::SquareWave do
  before :each do
    @sample_rate = 48000.0
    
    @c6 = Musicality::Pitch.new :octave => 6, :semitone => 0
    @e6 = Musicality::Pitch.new :octave => 6, :semitone => 4
    @g6 = Musicality::Pitch.new :octave => 6, :semitone => 7
    
    @pitches = [@c6, @e6, @g6]
  end
  
  it "should produce ones during first half-period, and zeros during second half-period" do
    @pitches.each do |pitch|
      wave = Musicality::SquareWave.new @sample_rate
      wave.start_pitch pitch
      
      samples_in_half_period = @sample_rate / (2.0 * pitch.ratio)
      
      wave.render_sample.should eq(1)
      
      samples_in_half_period.to_i.times do
        wave.render_sample.should eq(1)
      end

      samples_in_half_period.to_i.times do
        wave.render_sample.should eq(-1)
      end      

    end
  end

end

