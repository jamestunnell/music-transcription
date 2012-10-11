require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Triplet do
  before :all do
    @note1 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 15.0 ), 2.to_r)
    @note2 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 30.0 ), 2.to_r)
    @note3 = Musicality::Note.new(Musicality::Pitch.new( :ratio => 25.0 ), 2.to_r)
  end

  it "should not raise ArgumentError if notes are the same length" do
    lambda { Musicality::Triplet.new [ @note1, @note2, @note3 ] }.should_not raise_error ArgumentError
  end
    
  it "should raise ArgumentError if notes are not the same length" do
    notes = [ @note1, @note2, Musicality::Note.new(Musicality::Pitch.new( :ratio => 15.0 ), 1.to_r) ]
    lambda { Musicality::Triplet.new notes }.should raise_error ArgumentError
  end

end
