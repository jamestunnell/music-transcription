require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::NoteGroup do
  before :all do
    @note1 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 15.0 ), 2.to_r)
    @note2 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 30.0 ), 1.to_r)
    @note3 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 25.0 ), 3.to_r)
  end

  it "should raise ArgumentError if no notes are given during construction" do
    lambda { Musicality::NoteGroup.new [] }.should raise_error ArgumentError
  end

  it "should raise ArgumentError if less than two notes are given during construction" do
    lambda { Musicality::NoteGroup.new [ @note1 ] }.should raise_error ArgumentError
  end

  it "should not raise ArgumentError if exactly two notes are given during construction" do
    lambda { Musicality::NoteGroup.new [ @note1, @note2 ] }.should_not raise_error ArgumentError
  end

  it "should not raise ArgumentError if more than two notes are given during construction" do
    lambda { Musicality::NoteGroup.new [ @note1, @note2, @note3 ] }.should_not raise_error ArgumentError
  end

  it "should assign the :notes given during construction" do
    notes = [ @note1, @note2, @note3 ]
    group = Musicality::NoteGroup.new notes
    group.notes.should eq(notes.clone)
  end

  it "should raise ArgumentError if a non-Enumerable is given for notes" do
    lambda { Musicality::NoteGroup.new "b" }.should raise_error ArgumentError
  end

  it "should raise ArgumentError if a non-Note is include with the notes" do
    lambda { Musicality::NoteGroup.new [@note1, 5] }.should raise_error ArgumentError
  end
end
