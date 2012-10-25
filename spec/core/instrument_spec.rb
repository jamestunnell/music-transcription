require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class MyInstrClass
end

describe Musicality::Instrument do
  it "should assign the given class" do
    instr = Instrument.new :class => MyInstrClass
    instr.class.should eq(MyInstrClass)
  end

  it "should convert the given symbol and assign it to class" do
    instr = Instrument.new :symbol => :SineWave
    instr.class.should eq(Musicality::SineWave)
  end

  it "should convert the given string and assign it to class" do
    instr = Instrument.new :string => "SineWave"
    instr.class.should eq(Musicality::SineWave)
  end

  it "should assign the given class rather than using the given symbol or string" do
    instr = Instrument.new :string => "SineWave", :class => MyInstrClass, :symbol => :SineWave
    instr.class.should eq(MyInstrClass)
  end
  
  it "should assign the given settings" do
    settings = { 1 => "a", 2 => "b" }
    instr = Instrument.new :class => MyInstrClass, :settings => settings
    instr.settings.should eq(settings.clone)
  end
end
