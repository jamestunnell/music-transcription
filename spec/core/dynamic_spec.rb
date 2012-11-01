require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Dynamic do

  it "should assign loudness and offset as given during construction" do
    dyn = Musicality::Dynamic.new :loudness => 0.5, :offset => 2.to_r
    dyn.loudness.should eq(0.5)
    dyn.offset.should eq(2.to_r)
  end

  it "should assign default for event duration" do
    dyn = Musicality::Dynamic.new :loudness => 0.5, :offset => 0.to_r
    dyn.duration.should eq(0.to_r)
  end

  it "should assign event duration if given during construction" do
    dyn = Musicality::Dynamic.new :loudness => 0.5, :offset => 1.to_r, :duration => 1.25.to_r
    dyn.duration.should eq(1.25.to_r)
  end
end
