require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Part do
  before :each do
    @note1 = Musicality::Note.new :pitches => [Pitch.new], :duration => 0.25
    @note2 = Musicality::Note.new :pitches => [Pitch.new], :duration => 0.25
    @note3 = Musicality::Note.new :pitches => [Pitch.new], :duration => 0.25

    @sequences = [ 
      Musicality::Sequence.new( :offset => 0.0, :notes => [@note1, @note2, @note3] )
    ]
    
    @start_dynamic = Musicality::Dynamic.new( :loudness => 0.5, :offset => 0.to_r )
    
    @dynamic_changes = [
      Musicality::Dynamic.new( :loudness => 1.0, :duration => 2.to_r, :offset => 1.to_r),
    ]
    
    @id = "xyz"
  end
  
  it "should assign starting dynamic given during construction" do
    part = Musicality::Part.new :start_dynamic => @start_dynamic
    part.start_dynamic.should eq(@start_dynamic)
  end  
  
  it "should assign note sequences given during construction" do
    part = Musicality::Part.new :start_dynamic => @start_dynamic, :sequences => @sequences
    part.sequences.should eq(@sequences.clone)
  end
  
  it "should assign dynamic changes given during construction" do
    part = Musicality::Part.new :start_dynamic => @start_dynamic, :dynamic_changes => @dynamic_changes
    part.dynamic_changes.should eq(@dynamic_changes)
  end

  it "should assign id given during construction" do
    part = Musicality::Part.new :start_dynamic => @start_dynamic, :id => @id
    part.id.should eq(@id)
  end
end
