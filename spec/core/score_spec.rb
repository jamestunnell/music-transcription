require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Score do
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
    
    @note_groups =
    {
      2.to_r => Musicality::Chord.new( [@whole_note, @whole_note, @whole_note] ),
      3.to_r => Musicality::Triplet.new( [@quarter_note, @quarter_note, @quarter_note] )
    }
    
    @dynamics = 
    {
      0.to_r => Musicality::Dynamic.new( 0.5 ),
      1.to_r => Musicality::Dynamic.new( 1.0, 2.to_r ),
    }

    @parts = 
    {
      "piano (LH)" => Musicality::Part.new( :notes => @notes, :note_groups => @note_groups, :dynamics => @dynamics ),
      "piano (RH)" => Musicality::Part.new( :notes => @notes, :note_groups => @note_groups, :dynamics => @dynamics ),
    }    

    @tempos = 
    {
      0.to_r => Musicality::Tempo.new( 100, 0.25.to_r ),
      2.to_r => Musicality::Tempo.new( 130, 0.25.to_r ),
    }
  end
  
  describe Musicality::Score.new do
    its(:parts) { should be_empty }
    its(:notes) { should be_empty }
    its(:note_groups) { should be_empty }
    its(:dynamics) { should be_empty }
    its(:tempos) { should be_empty }    
  end

  it "should assign parts given during construction" do
    score = Musicality::Score.new :parts => @parts
    score.parts.should eq(@parts.clone)
  end
  
  it "should assign notes given during construction" do
    score = Musicality::Score.new :notes => @notes
    score.notes.should eq(@notes.clone)
  end
  
  it "should assign note groups given during construction" do
    score = Musicality::Score.new :note_groups => @note_groups
    score.note_groups.should eq(@note_groups.clone)
  end
  
  it "should assign dynamics given during construction" do
    score = Musicality::Score.new :dynamics => @dynamics
    score.dynamics.should eq(@dynamics.clone)
  end

  it "should assign tempos given during construction" do
    score = Musicality::Score.new :tempos => @tempos
    score.tempos.should eq(@tempos.clone)
  end
end
