require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Sequence do
  before :all do
    @note1 = Musicality::Note.new(:pitches => [Musicality::PitchConstants::C3], :duration => 2)
    @note2 = Musicality::Note.new(:pitches => [Musicality::PitchConstants::D3], :duration => 1)
    @note3 = Musicality::Note.new(:pitches => [Musicality::PitchConstants::E3], :duration => 3)
  end

  it "should raise ArgumentError if no notes are given during construction" do
    lambda { Musicality::Sequence.new }.should raise_error ArgumentError
  end

  it "should not raise ArgumentError if exactly two notes are given during construction" do
    lambda { Musicality::Sequence.new( :offset => 0.0, :notes => [ @note1, @note2 ]) }.should_not raise_error ArgumentError
  end

  it "should not raise ArgumentError if more than two notes are given during construction" do
    lambda { Musicality::Sequence.new( :offset => 0.0, :notes=> [ @note1, @note2, @note3 ]) }.should_not raise_error ArgumentError
  end

  it "should assign the :notes given during construction" do
    notes = [ @note1, @note2, @note3 ]
    group = Musicality::Sequence.new :offset => 0.0, :notes => notes
    group.notes.should eq(notes.clone)
  end

  it "should raise ArgumentError if a non-Array is given for notes" do
    lambda { Musicality::Sequence.new( :offset => 0.0, :notes => "b") }.should raise_error ArgumentError
  end

  it "should raise ArgumentError if a non-Note is include with the notes" do
    lambda { Musicality::Sequence.new( :offset => 0.0, :notes => [@note1, 5]) }.should raise_error ArgumentError
  end
  
  it "should compute duration according to sum of notes in sequence" do
    notes = [@note1, @note2, @note3 ]
    seq = Musicality::Sequence.new :offset => 0.0, :notes => notes
    seq.duration.should eq(6.0)
  end
end
