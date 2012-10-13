require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Part do
  before :each do
    @quarter_note = Musicality::Note.new( Pitch.new, 0.25.to_r )
    @whole_note = Musicality::Note.new( Pitch.new, 1.to_r )

    @notes = 
    {
      0.to_r => @quarter_note,
      0.25.to_r => @quarter_note,
      0.5.to_r => @quarter_note,
      0.75.to_r => @quarter_note,
      1.to_r => @whole_note
    }
    
    @note_sequences =
    {
      2.to_r => Musicality::Chord.new( [@whole_note, @whole_note, @whole_note] ),
      3.to_r => Musicality::Tuplet.new( [@quarter_note, @quarter_note, @quarter_note] )
    }
    
    @dynamics = 
    {
      0.to_r => Musicality::Dynamic.new( 0.5 ),
      1.to_r => Musicality::Dynamic.new( 1.0, 2.to_r ),
    }
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
