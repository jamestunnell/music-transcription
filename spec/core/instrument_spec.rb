require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Instrument do

  describe Musicality::Instrument.new do
    its(:class_name) { should_not be_empty }
    its(:settings) { should be_empty }
  end
  
  it "should assign the given class" do
    instr = Instrument.new :class_name => Musicality::SineWave.name
    instr.class_name.should eq(Musicality::SineWave.name)
  end
  
  it "should assign the given settings" do
    settings = { 1 => "a", 2 => "b" }
    instr = Instrument.new :settings => settings
    instr.settings.should eq(settings.clone)
  end
  
  it "should be hash-makeable" do
    Musicality::HashMakeUtil.is_hash_makeable?(Musicality::Instrument).should be_true
    
    settings = { 1 => "a", 2 => "b" }
    hash = { :class_name => "Musicality::TriangleWave", :settings => settings }
    instr = Instrument.make_from_hash hash
    hash2 = instr.save_to_hash
    hash.should eq(hash2)
    
    instr2 = Instrument.make_from_hash hash2
    
    instr.class_name.should eq(instr2.class_name)
    instr.settings.should eq(instr2.settings)
  end
end
