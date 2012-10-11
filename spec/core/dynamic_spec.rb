require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Dynamic do

  it "should assign defaults for transition duration and type if not given during construction" do
    dyn = Musicality::Dynamic.new 0.5
    dyn.transition_duration.should eq(0.to_r)
    dyn.transition_type.should eq(Musicality::Dynamic::TRANSITION_LINEAR)
  end
  
  it "should assign transition duration if given during construction" do
    dyn = Musicality::Dynamic.new 0.5, 1.to_r
    dyn.transition_duration.should eq(1.to_r)
  end

  it "should assign transition duration if given during construction" do
    dyn = Musicality::Dynamic.new 0.5, 1.to_r, Musicality::Dynamic::TRANSITION_SIGMOID
    dyn.transition_duration.should eq(1.to_r)
    dyn.transition_type.should eq(Musicality::Dynamic::TRANSITION_SIGMOID)
  end
end
