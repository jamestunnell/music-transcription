require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::SawtoothWave do
  before :each do
    @sample_rate = 96000.0
    @pitches = [
      Musicality::PitchConstants::C2,
      Musicality::PitchConstants::E2,
      Musicality::PitchConstants::G2
    ]
  end
  
  it "should produce positive increasing samples during first half-period, and negative increasing samples second half-period" do
    @pitches.each do |pitch|
      wave = Musicality::SawtoothWave.new @sample_rate, pitch.freq
      
      samples_in_half_period = @sample_rate / (2.0 * pitch.freq)
      
      prev = wave.render_sample
      prev.should eq(0)
      
      samples_in_half_period.to_i.times do
        current = wave.render_sample
        current.should be > 0.0
        current.should be > prev
        prev = current
      end

      prev= wave.render_sample
      prev.should be_within(0.01).of(-1)
      
      (samples_in_half_period - 1).to_i.times do
        current = wave.render_sample
        current.should be < 0.0
        current.should be > prev
        prev = current
      end
      
    end
  end

end

