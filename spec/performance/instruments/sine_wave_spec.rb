require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::SineWave do
  before :each do
    @sample_rate = 96000.0
    @pitches = [
      Musicality::PitchConstants::C2,
      Musicality::PitchConstants::E2,
      Musicality::PitchConstants::G2
    ]
  end
  
  it "should produce zero during every half-period, and non-zeros between" do
    @pitches.each do |pitch|
      wave = Musicality::SineWave.new @sample_rate, pitch.freq
      
      samples_in_half_period = @sample_rate / (2.0 * pitch.freq)
      
      wave.render_sample.should be_within(0.01).of(0.0)
      (samples_in_half_period - 1).to_i.times do
        wave.render_sample.should_not eq(0)
      end
      wave.render_sample.should be_within(0.01).of(0.0)
      
    end
  end

end

