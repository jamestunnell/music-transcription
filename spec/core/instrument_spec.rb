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
end
