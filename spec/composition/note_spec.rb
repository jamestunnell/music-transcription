require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Note do
  before :each do
    @pitch = Musicality::Pitch.new( :ratio => 120.0 )
  end

  it "should be constructible (no raised exceptions) without the optional parameters" do
    lambda { Musicality::Note.new :pitch => @pitch, :duration => 1.to_r, :offset => 0.to_r }.should_not raise_error ArgumentError
    lambda { Musicality::Note.new :pitch => @pitch, :duration => 1.to_r, :offset => 0.to_r }.should_not raise_error RangeError
  end
  
  it "should assign pitch and duration parameters when given during construction" do
    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r
    note.pitch.ratio.should eq(@pitch.ratio)
    note.duration.should eq(Rational(2,1)) 
  end

  it "should assign :loudness, :intensity, and :seperation parameters if given during construction" do
    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r, :loudness => 0.1, :intensity => 0.2, :seperation => 0.3
    note.loudness.should eq(0.1)
    note.intensity.should eq(0.2)
    note.seperation.should eq(0.3)
  end

  it "should assign :tie and parameter if given during construction" do
    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r, :tie => false
    note.tie.should be_false

    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r, :tie => true
    note.tie.should be_true
  end
  
  it "should assign pitch" do
    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r
    new_pitch = Musicality::Pitch.new :ratio => 55.0
    note.pitch = new_pitch
    note.pitch.ratio.should eq new_pitch.ratio
  end

  it "should assign duration" do
    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r
    note.duration = 3.to_r
    note.duration.should eq 3.to_r
  end

  it "should assign loudness" do
    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r
    note.loudness = 0.123
    note.loudness.should eq 0.123
  end

  it "should assign intensity" do
    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r
    note.intensity = 0.123
    note.intensity.should eq 0.123
  end
  
  it "should assign seperation" do
    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r
    note.seperation = 0.123
    note.seperation.should eq 0.123
  end

  it "should assign tie" do
    note = Musicality::Note.new :pitch => @pitch, :duration => 2.to_r, :offset => 0.to_r
    note.tie.should be_false
    note.tie = true
    note.tie.should be_true
  end
end
