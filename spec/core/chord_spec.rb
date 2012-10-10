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
      Musicality::Note.new({:ratio => 1.5}),
      Musicality::Note.new({:ratio => 2.5}),
      Musicality::Note.new({:ratio => 25.0})
    ]
    chord = Musicality::Chord.new :notes => notes
    chord.notes.should eq(notes)
  end

end
