require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::NoteTimeConverter do
  context "#time_elapsed" do
    context "constant tempo" do
      before :each do 
        tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0
        @tempo_computer = Musicality::TempoComputer.new tempo
        sample_rate = 48
        @converter = Musicality::NoteTimeConverter.new @tempo_computer, sample_rate
      end
  
      it "should return a time of zero when note end is zero." do
        @converter.time_elapsed(0, 0).should eq(0)
      end
      
      it "should return a time of 1 second when note end is equal to the initial notes-per-second" do
        note_end = @tempo_computer.notes_per_second_at(0)
        @converter.time_elapsed(0, note_end).should eq(1)
      end
    end
    
    context "linear tempo-change" do
      before :each do 
        tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0
        tempo2 = Musicality::Tempo.new :beats_per_minute => 60, :beat_duration => 0.25, :offset => 1.0, :duration => 1.0
        
        @tempo_computer = Musicality::TempoComputer.new tempo, [tempo2]
        sample_rate = 200
        @converter = Musicality::NoteTimeConverter.new @tempo_computer, sample_rate
      end
  
      it "should return a time of zero when note end is zero." do
        @converter.time_elapsed(0.0, 0.0).should eq(0.0)
      end
  
      it "should return a time of 3 sec during a 1-note long transition from 120bpm to 60bpm" do
        @tempo_computer.notes_per_second_at(1.0).should eq(0.5)
        @tempo_computer.notes_per_second_at(2.0).should eq(0.25)
  
        @converter.time_elapsed(1.0, 2.0).should be_within(0.05).of(2.77)
      end
  
    end
  end
  
  context "#map_note_offsets_to_time_offsets" do
    context "constant tempo" do
      before :each do 
        tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0
        @tempo_computer = Musicality::TempoComputer.new tempo
        sample_rate = 4800
        @converter = Musicality::NoteTimeConverter.new @tempo_computer, sample_rate
      end
  
      it "should map offset 0.0 to time 0.0" do
        map = @converter.map_note_offsets_to_time_offsets [0.0]
        map[0.0].should eq(0.0)
      end

      it "should map offset 0.25 to time 0.5" do
        map = @converter.map_note_offsets_to_time_offsets [0.0, 0.25]
        map[0.25].should eq(0.5)
      end
      
      it "should map offset 1.0 to time 2.0" do
        map = @converter.map_note_offsets_to_time_offsets [0.0, 1.0]
        map[1.0].should eq(2.0)
      end
    end
    #
    #context "linear tempo-change" do
    #  before :each do 
    #    tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0
    #    tempo2 = Musicality::Tempo.new :beats_per_minute => 60, :beat_duration => 0.25, :offset => 1.0, :duration => 1.0
    #    
    #    @tempo_computer = Musicality::TempoComputer.new tempo, [tempo2]
    #    sample_rate = 200
    #    @converter = Musicality::NoteTimeConverter.new @tempo_computer, sample_rate
    #  end
    #
    #  it "should return a time of zero when note end is zero." do
    #    @converter.time_elapsed(0.0, 0.0).should eq(0.0)
    #  end
    #
    #  it "should return a time of 3 sec during a 1-note long transition from 120bpm to 60bpm" do
    #    @tempo_computer.notes_per_second_at(1.0).should eq(0.5)
    #    @tempo_computer.notes_per_second_at(2.0).should eq(0.25)
    #
    #    @converter.time_elapsed(1.0, 2.0).should be_within(0.05).of(2.77)
    #  end
    #
    #end    
  end
end
