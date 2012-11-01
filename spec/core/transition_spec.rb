require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Transition do

  it "should assign transition duration given during construction" do
    transition = Musicality::Transition.new 0.to_r
    transition.duration.should eq(0.to_r)
  end

  it "should assign defaults for transition shape if not given during construction" do
    transition = Musicality::Transition.new 0.to_r
    transition.shape.should eq(Musicality::Transition::SHAPE_LINEAR)
  end
  
  it "should assign transition shape if given during construction" do
    transition = Musicality::Transition.new 1.to_r, Musicality::Transition::SHAPE_SIGMOID
    transition.shape.should eq(Musicality::Transition::SHAPE_SIGMOID)
  end
end
