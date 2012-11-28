require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::TriangleWave do
  before :each do
    @sample_rate = 96000.0
    @pitches = [
      Musicality::PitchConstants::C2,
      Musicality::PitchConstants::E2,
      Musicality::PitchConstants::G2
    ]
  end
  
  it "should produce increasing samples during first half-period, and decreasing samples during the second half-period" do
    @pitches.each do |pitch|
      wave = Musicality::TriangleWave.new @sample_rate, pitch.freq
      
      samples_in_half_period = @sample_rate / (2.0 * pitch.freq)
      
      prev = wave.render_sample
      prev.should eq(-1)
      
      (samples_in_half_period - 1).to_i.times do
        current = wave.render_sample
        current.should be > prev
        prev = current
      end

      wave.render_sample.should be_within(0.01).of(1)
      
      prev = wave.render_sample
      prev.should be_within(0.01).of(1)
      
      (samples_in_half_period - 1).to_i.times do
        current = wave.render_sample
        current.should be < prev
        prev = current
      end
      
      wave.render_sample.should be_within(0.01).of(-1)
    end
  end

end

