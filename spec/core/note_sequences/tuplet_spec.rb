require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Tuplet do
  before :all do
    @note1 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 15.0 ), 2.to_r)
    @note2 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 30.0 ), 2.to_r)
    @note3 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 30.0 ), 2.to_r)
    @note4 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 25.0 ), 1.to_r)
  end

  it "should not raise ArgumentError if notes are the same length" do
    lambda { Musicality::Tuplet.new [ @note1, @note2, @note3 ] }.should_not raise_error ArgumentError
  end

  it "should assign a default modifier of 2/3 if not given during construction" do
    notes = [ @note1, @note2, @note3 ]
    tuplet = Musicality::Tuplet.new notes
    tuplet.modifier.should == Rational(2,3)
  end

  it "should assign a modifier given during construction" do
    notes = [ @note1, @note2, @note3 ]
    tuplet = Musicality::Tuplet.new notes, Rational(1,3)
    tuplet.modifier.should == Rational(1,3)
  end
      
  it "should not raise ArgumentError if notes are not the same length" do
    notes = [ @note1, @note2, @note4 ]
    lambda { Musicality::Tuplet.new notes }.should_not raise_error ArgumentError
  end

end
