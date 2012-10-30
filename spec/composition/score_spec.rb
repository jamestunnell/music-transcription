require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Score do
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
    
    @parts = 
    [
      Musicality::Part.new( :sequences => @sequences, :dynamics => @dynamics, :name => "piano (LH)" ),
      Musicality::Part.new( :sequences => @sequences, :dynamics => @dynamics, :name => "piano (RH)" ),
    ]

    @tempos = 
    [
      Musicality::Tempo.new( :beats_per_minute => 100, :beat_duration => 0.25.to_r, :offset => 0.to_r ),
      Musicality::Tempo.new( :beats_per_minute => 130, :beat_duration => 0.25.to_r, :offset => 2.to_r ),
    ]
  end
  
  describe Musicality::Score.new do
    its(:parts) { should be_empty }
    its(:tempos) { should be_empty }    
  end

  it "should assign parts given during construction" do
    score = Musicality::Score.new :parts => @parts
    score.parts.should eq(@parts.clone)
  end

  it "should assign tempos given during construction" do
    score = Musicality::Score.new :tempos => @tempos
    score.tempos.should eq(@tempos.clone)
  end
end
