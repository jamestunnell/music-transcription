require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::SawtoothWave do
  before :each do
    @sample_rate = 48000.0
    
    @c6 = Musicality::Pitch.new :octave => 6, :semitone => 0
    @e6 = Musicality::Pitch.new :octave => 6, :semitone => 4
    @g6 = Musicality::Pitch.new :octave => 6, :semitone => 7
    
    @pitches = [@c6, @e6, @g6]
  end
  
  it "should produce positive increasing samples during first half-period, and negative increasing samples second half-period" do
    @pitches.each do |pitch|
      wave = Musicality::SawtoothWave.new @sample_rate
      wave.start_pitch pitch
      
      samples_in_half_period = @sample_rate / (2.0 * pitch.ratio)
      
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

