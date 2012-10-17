require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Instrument do
  describe Instrument.new do
    its(:name) { should == "default" }
    its(:options) { should be_empty }
  end
  
  it "should assign the given name" do
    instr = Instrument.new "my_instr"
    instr.name.should eq("my_instr")
  end
  
  it "should assign the given options" do
    options = { 1 => "a", 2 => "b" }
    instr = Instrument.new "my_instr", options
    instr.options.should eq(options.clone)
  end
end
