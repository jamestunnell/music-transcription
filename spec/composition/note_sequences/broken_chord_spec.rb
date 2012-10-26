require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::BrokenChord do
  before :all do
    @notes = 
    [
      Musicality::Note.new(:pitch => Musicality::Pitch.new( :ratio => 15.0 ), :duration => 2.to_r, :offset => 0.to_r),
      Musicality::Note.new(:pitch => Musicality::Pitch.new( :ratio => 30.0 ), :duration => 2.to_r, :offset => 0.to_r),
      Musicality::Note.new(:pitch => Musicality::Pitch.new( :ratio => 25.0 ), :duration => 2.to_r, :offset => 0.to_r),
    ]
  end

  it "should be constructible (no error raised) without optional parameters" do
    lambda { Musicality::BrokenChord.new @notes }.should_not raise_error ArgumentError
  end  

  it "should not raise ArgumentError if notes are the same length" do
    lambda { Musicality::BrokenChord.new @notes }.should_not raise_error ArgumentError
  end
    
  it "should raise ArgumentError if notes are not the same length" do
    notes = @notes.clone
    notes << Musicality::Note.new(:pitch => Musicality::Pitch.new( :ratio => 15.0 ), :duration => 1.to_r, :offset => 0.to_r)

    lambda { Musicality::BrokenChord.new notes }.should raise_error ArgumentError
  end
  
  it "should assign the :strum_duration as given during construction" do
    BrokenChord = Musicality::BrokenChord.new @notes, @notes.first.duration
    BrokenChord.strum_duration.should eq(@notes.first.duration)
  end
  
  it "should not raise ArgumentError if :strum_duration is less than or equal to note duration" do
    lambda { Musicality::BrokenChord.new @notes, 1.99.to_r }.should_not raise_error ArgumentError
  end

  it "should raise ArgumentError if :strum_duration is more than note duration" do
    lambda { Musicality::BrokenChord.new @notes, 2.01.to_r }.should raise_error ArgumentError
  end
end
