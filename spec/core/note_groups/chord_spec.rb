require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Chord do
  before :all do
    @notes = 
    [
      Musicality::Note.new(Musicality::Pitch.new( :ratio => 15.0 ), 2.to_r),
      Musicality::Note.new(Musicality::Pitch.new( :ratio => 30.0 ), 2.to_r),
      Musicality::Note.new(Musicality::Pitch.new( :ratio => 25.0 ), 2.to_r),
    ]
  end

  it "should be constructible (no error raised) without optional parameters" do
    lambda { Musicality::Chord.new @notes }.should_not raise_error ArgumentError
  end  

  it "should not raise ArgumentError if notes are the same length" do
    lambda { Musicality::Chord.new @notes }.should_not raise_error ArgumentError
  end
    
  it "should raise ArgumentError if notes are not the same length" do
    notes = @notes.clone
    notes << Musicality::Note.new(Musicality::Pitch.new( :ratio => 15.0 ), 1.to_r)

    lambda { Musicality::Chord.new notes }.should raise_error ArgumentError
  end

  it "should set arpeggiate to false if not given during construction" do
    chord = Musicality::Chord.new @notes
    chord.arpeggiate.should be false
  end
  
  it "should assign the :arpeggiate flag as given during construction" do
    chord = Musicality::Chord.new @notes, :arpeggiate => true
    chord.arpeggiate.should be true
    chord = Musicality::Chord.new @notes, :arpeggiate => false
    chord.arpeggiate.should be false
  end

  it "should assign the :arpeggiation_duration as given during construction" do
    chord = Musicality::Chord.new @notes, :arpeggiation_duration => @notes.first.duration
    chord.arpeggiation_duration.should eq(@notes.first.duration)
  end
  
  it "should not raise ArgumentError if :arpeggiation_duration is less than or equal to note duration" do
    lambda { Musicality::Chord.new @notes, :arpeggiation_duration => 1.99.to_r }.should_not raise_error ArgumentError
  end

  it "should raise ArgumentError if :arpeggiation_duration is more than note duration" do
    lambda { Musicality::Chord.new @notes, :arpeggiation_duration => 2.01.to_r }.should raise_error ArgumentError
  end
end
