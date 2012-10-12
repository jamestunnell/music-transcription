require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Tempo do

  it "should assign beats per minute and beat duration as given during construction" do
    tempo = Musicality::Tempo.new 120, 0.25.to_r
    tempo.beats_per_minute.should eq(120)
    tempo.beat_duration.should eq(0.25.to_r)
  end

  it "should assign defaults for transition duration and type if not given during construction" do
    tempo = Musicality::Tempo.new 120, 0.25.to_r
    tempo.transition.duration.should eq(0.to_r)
    tempo.transition.shape.should eq(Musicality::Transition::SHAPE_LINEAR)
  end
  
  it "should assign transition duration if given during construction" do
    tempo = Musicality::Tempo.new 120, 0.25.to_r, 1.to_r
    tempo.transition.duration.should eq(1.to_r)
  end

  it "should assign transition shape if given during construction" do
    tempo = Musicality::Tempo.new 120, 0.25.to_r, 1.to_r, Musicality::Transition::SHAPE_SIGMOID
    tempo.transition.shape.should eq(Musicality::Transition::SHAPE_SIGMOID)
  end
end
