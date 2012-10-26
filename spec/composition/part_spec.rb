require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Part do
  before :each do
    @note1 = Musicality::Note.new(:pitch => Pitch.new, :duration => 0.25.to_r, :offset => 0.to_r )
    @note2 = Musicality::Note.new(:pitch => Pitch.new, :duration => 0.25.to_r, :offset => 0.25.to_r )
    @note3 = Musicality::Note.new(:pitch => Pitch.new, :duration => 0.25.to_r, :offset => 0.50.to_r )

    @notes = [ @note1, @note2, @note3 ]
    
    @note_sequences = [ 
      Musicality::BrokenChord.new( [@note1, @note2, @note3] ),
      Musicality::Tuplet.new( [@note1, @note2, @note3] )
    ]
    
    @dynamics = [
      Musicality::Dynamic.new( :loudness => 0.5, :offset => 0.to_r ),
      Musicality::Dynamic.new( :loudness => 1.0, :duration => 2.to_r, :offset => 1.to_r),
    ]
  end
  
  describe Musicality::Part.new do
    its(:notes) { should be_empty }
    its(:note_sequences) { should be_empty }
    its(:dynamics) { should be_empty }
  end
  
  it "should assign notes given during construction" do
    part = Musicality::Part.new :notes => @notes
    part.notes.should eq(@notes.clone)
  end
  
  it "should assign note sequences given during construction" do
    part = Musicality::Part.new :note_sequences => @note_sequences
    part.note_sequences.should eq(@note_sequences.clone)
  end
  
  it "should assign dynamics given during construction" do
    part = Musicality::Part.new :dynamics => @dynamics
    part.dynamics.should eq(@dynamics.clone)
  end
end
