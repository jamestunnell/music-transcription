require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Score do
  before :each do
    @note1 = Musicality::Note.new :pitches => [Pitch.new], :duration => 0.25
    @note2 = Musicality::Note.new :pitches => [Pitch.new], :duration => 0.25
    @note3 = Musicality::Note.new :pitches => [Pitch.new], :duration => 0.25

    @sequences = [ 
      Musicality::Sequence.new( :offset => 0.0, :notes => [@note1, @note2, @note3] )
    ]
    
    @start_dynamic = Musicality::Dynamic.new( :loudness => 0.5, :offset => 0.0 )
    
    @dynamic_changes = [
      Musicality::Dynamic.new( :loudness => 1.0, :duration => 0.5, :offset => 0.25)
    ]
      
    @parts = 
    [
      Musicality::Part.new( :start_dynamic => @start_dynamic, :sequences => @sequences, :dynamic_changes => @dynamic_changes, :id => "piano (LH)" ),
    ]

    @start_tempo = Musicality::Tempo.new( :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0 )
    
    @tempo_changes = [
      Musicality::Tempo.new( :beats_per_minute => 60, :beat_duration => 0.25, :offset => 0.5, :duration => 0.25 ),
    ]
    
    @program = Musicality::Program.new :segments => [0...0.75, 0...0.75]
  end
  
  it "should assign reqd args given during construction" do
    score = Musicality::Score.new :start_tempo => @start_tempo, :program => @program
    score.start_tempo.should eq(@start_tempo)
    score.program.should eq(@program)
  end

  it "should  default parts to empty" do
    score = Musicality::Score.new :start_tempo => @start_tempo, :program => @program
    score.parts.should be_empty
  end

  it "should  default tempo_changes to empty" do
    score = Musicality::Score.new :start_tempo => @start_tempo, :program => @program
    score.tempo_changes.should be_empty
  end
  
  it "should assign optional args given during construction" do
    score = Musicality::Score.new :start_tempo => @start_tempo, :program => @program, :parts => @parts, :tempo_changes => @tempo_changes
    score.parts.should eq(@parts)
    score.tempo_changes.should eq(@tempo_changes)
  end
end
