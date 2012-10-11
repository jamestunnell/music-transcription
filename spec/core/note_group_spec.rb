require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::NoteGroup do
  before :all do
    @note1 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 15.0 ), 2.to_r)
    @note2 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 30.0 ), 1.to_r)
    @note3 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 25.0 ), 3.to_r)
  end

  it "should raise ArgumentError if no notes are given during construction" do
    lambda { Musicality::NoteGroup.new [], Musicality::NoteGroup::NOTE_GROUP_PHRASE }.should raise_error ArgumentError
  end

  it "should raise ArgumentError if less than two notes are given during construction" do
    lambda { Musicality::NoteGroup.new [ @note1 ], Musicality::NoteGroup::NOTE_GROUP_PHRASE }.should raise_error ArgumentError
  end

  it "should not raise ArgumentError if exactly two notes are given during construction" do
    lambda { Musicality::NoteGroup.new [ @note1, @note2 ], Musicality::NoteGroup::NOTE_GROUP_PHRASE }.should_not raise_error ArgumentError
  end

  it "should not raise ArgumentError if more than two notes are given during construction" do
    lambda { Musicality::NoteGroup.new [ @note1, @note2, @note3 ], Musicality::NoteGroup::NOTE_GROUP_PHRASE }.should_not raise_error ArgumentError
  end

  it "should assign the :notes given during construction" do
    notes = [ @note1, @note2, @note3 ]
    group = Musicality::NoteGroup.new notes, Musicality::NoteGroup::NOTE_GROUP_PHRASE
    group.notes.should eq(notes.clone)
  end

  it "should raise ArgumentError if a non-Enumerable is given for notes" do
    lambda { Musicality::NoteGroup.new "b", Musicality::NoteGroup::NOTE_GROUP_PHRASE }.should raise_error ArgumentError
  end

  it "should raise ArgumentError if a non-Note is include with the notes" do
    lambda { Musicality::NoteGroup.new [@note1, 5], Musicality::NoteGroup::NOTE_GROUP_PHRASE }.should raise_error ArgumentError
  end

  it "should not raise ArgumentError if a valid note group type is given during construction" do
    Musicality::NoteGroup::VALID_NOTE_GROUPS.each do |type|
      lambda { Musicality::NoteGroup.new [ @note1, @note2 ], type }.should_not raise_error ArgumentError
    end
  end

  it "should raise ArgumentError if a non-valid note group type is given during construction" do
    lambda { Musicality::NoteGroup.new [ @note1, @note2 ], :noteGroupMyOwnThing }.should raise_error ArgumentError
  end
end
