require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Dynamic do

  it "should assign loudness as given during construction" do
    dyn = Musicality::Dynamic.new 0.5
    dyn.loudness.should eq(0.5)
  end

  it "should assign defaults for transition duration and type if not given during construction" do
    dyn = Musicality::Dynamic.new 0.5
    dyn.transition.duration.should eq(0.to_r)
    dyn.transition.shape.should eq(Musicality::Transition::SHAPE_LINEAR)
  end
  
  it "should assign transition duration if given during construction" do
    dyn = Musicality::Dynamic.new 0.5, 1.to_r
    dyn.transition.duration.should eq(1.to_r)
  end

  it "should assign transition shape if given during construction" do
    dyn = Musicality::Dynamic.new 0.5, 1.to_r, Musicality::Transition::SHAPE_SIGMOID
    dyn.transition.shape.should eq(Musicality::Transition::SHAPE_SIGMOID)
  end
end
