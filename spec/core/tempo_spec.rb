require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Tempo do

  it "should assign beats per minute, beat duration, and offset as given during construction" do
    tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25.to_r, :offset => 1.5.to_r
    tempo.beats_per_minute.should eq(120)
    tempo.beat_duration.should eq(0.25.to_r)
    tempo.offset.should eq(1.5.to_r)
  end

  it "should assign default for event duration and type if not given during construction" do
    tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25.to_r, :offset => 0.to_r
    tempo.duration.should eq(0.to_r)
  end
  
  it "should assign transition duration if given during construction" do
    tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25.to_r, :offset => 0.to_r, :duration => 1.to_r
    tempo.duration.should eq(1.to_r)
  end
end
