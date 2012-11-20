require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Dynamic do

  it "should assign loudness and offset as given during construction" do
    dyn = Musicality::Dynamic.new :loudness => 0.5, :offset => 2.0
    dyn.loudness.should eq(0.5)
    dyn.offset.should eq(2.to_r)
  end

  it "should assign default for event duration" do
    dyn = Musicality::Dynamic.new :loudness => 0.5, :offset => 0.0
    dyn.duration.should eq(0.to_r)
  end

  it "should assign event duration if given during construction" do
    dyn = Musicality::Dynamic.new :loudness => 0.5, :offset => 1, :duration => 1.25
    dyn.duration.should eq(1.25.to_r)
  end
  
  it "should be hash-makeable" do
    Musicality::HashMakeUtil.is_hash_makeable?(Musicality::Dynamic).should be_true
    
    hash = { :loudness => 0.2, :offset => 2.1, :duration => 1.5 }
    obj = Musicality::Dynamic.make_from_hash hash
    hash2 = obj.save_to_hash
    hash.should eq(hash2)
    
    obj2 = Musicality::Dynamic.make_from_hash hash2
    obj.loudness.should eq(obj2.loudness)
    obj.offset.should eq(obj2.offset)
    obj.duration.should eq(obj2.duration)
  end
end
