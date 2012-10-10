require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Chord do
  it "should be constructible (no error raised) with no parameters" do
    lambda { Musicality::Chord.new }.should_not raise_error ArgumentError
  end  

  it "should default to no notes if :notes are not given during construction" do
    chord = Musicality::Chord.new
    chord.notes.should be_empty
  end  
  
  it "should assign the :notes given during construction" do
    notes = 
    [
      Musicality::Note.new(:pitch => Musicality::Pitch.new({:ratio => 1.5})),
      Musicality::Note.new(:pitch => Musicality::Pitch.new({:ratio => 1.5})),
      Musicality::Note.new(:pitch => Musicality::Pitch.new({:ratio => 1.5})),
    ]
    chord = Musicality::Chord.new :notes => notes
    chord.notes.should eq(notes.clone)
  end

  it "should not raise ArgumentError if notes are the same length" do
    notes = 
    [
      Musicality::Note.new({:duration => 0.25.to_r}),
      Musicality::Note.new({:duration => 0.25.to_r}),
      Musicality::Note.new({:duration => 0.25.to_r})
    ]
    lambda { Musicality::Chord.new :notes => notes }.should_not raise_error ArgumentError
  end

  it "should raise ArgumentError if a non-Enumerable is given for :notes" do
    lambda { Musicality::Chord.new :notes => "b" }.should raise_error ArgumentError
  end

  it "should raise ArgumentError if a non-Note is part of the Array given for :notes" do
    notes = [ Musicality::Note.new, Musicality::Note.new, 5 ]
    lambda { Musicality::Chord.new :notes => notes }.should raise_error ArgumentError
  end
    
  it "should raise ArgumentError if notes are not the same length" do
    notes = 
    [
      Musicality::Note.new({:duration => 1.5.to_r}),
      Musicality::Note.new({:duration => 1.5.to_r}),
      Musicality::Note.new({:duration => 1.25.to_r})
    ]
    
    lambda { Musicality::Chord.new :notes => notes }.should raise_error ArgumentError
  end

  it "should set arpeggiate to false if not given during construction" do
    chord = Musicality::Chord.new
    chord.arpeggiate.should be false
  end
  
  it "should assign the :arpeggiate flag as given during construction" do
    chord = Musicality::Chord.new :arpeggiate => true
    chord.arpeggiate.should be true
    chord = Musicality::Chord.new :arpeggiate => false
    chord.arpeggiate.should be false
  end
end
