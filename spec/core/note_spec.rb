require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Note do
  it "should be constructible (no raised exceptions) with no parameters" do
    lambda { Musicality::Note.new }.should_not raise_error ArgumentError
    lambda { Musicality::Note.new }.should_not raise_error RangeError
  end
  
  it "should assign :pitch and :duration parameters" do
    note = Musicality::Note.new :pitch => Musicality::Pitch.new, :duration => 2.to_r
    note.pitch.ratio.should eq(1.0)
    note.duration.should eq(Rational(2,1)) 
  end

  it "should assign :loudness, :intensity, and :seperation parameters" do
    note = Musicality::Note.new :loudness => 0.1, :intensity => 0.2, :seperation => 0.3
    note.loudness.should eq(0.1)
    note.intensity.should eq(0.2)
    note.seperation.should eq(0.3)
  end
end
