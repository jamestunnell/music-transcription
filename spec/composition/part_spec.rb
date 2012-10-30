require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Part do
  before :each do
    @note1 = Musicality::Note.new :pitch => Pitch.new, :duration => 0.25
    @note2 = Musicality::Note.new :pitch => Pitch.new, :duration => 0.25
    @note3 = Musicality::Note.new :pitch => Pitch.new, :duration => 0.25

    @sequences = [ 
      Musicality::Sequence.new( :offset => 0.0, :notes => [@note1, @note2, @note3] )
    ]
    
    @dynamics = [
      Musicality::Dynamic.new( :loudness => 0.5, :offset => 0.to_r ),
      Musicality::Dynamic.new( :loudness => 1.0, :duration => 2.to_r, :offset => 1.to_r),
    ]
  end
  
  describe Musicality::Part.new do
    its(:sequences) { should be_empty }
    its(:dynamics) { should be_empty }
  end
  
  it "should assign note sequences given during construction" do
    part = Musicality::Part.new :sequences => @sequences
    part.sequences.should eq(@sequences.clone)
  end
  
  it "should assign dynamics given during construction" do
    part = Musicality::Part.new :dynamics => @dynamics
    part.dynamics.should eq(@dynamics.clone)
  end
end
