require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::SquareWave do
  before :each do
    @sample_rate = 96000.0
    @pitches = [
      Musicality::PitchConstants::C2,
      Musicality::PitchConstants::E2,
      Musicality::PitchConstants::G2
    ]
  end
  
  it "should produce ones during first half-period, and zeros during second half-period" do
    @pitches.each do |pitch|
      wave = Musicality::SquareWave.new :sample_rate => @sample_rate
      wave.start_pitch pitch
      
      samples_in_half_period = @sample_rate / (2.0 * pitch.freq)
      
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

