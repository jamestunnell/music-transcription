require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::NoteTimeConverter do
  
  context "constant tempo" do
    before :each do 
      tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25.to_r, :offset => 0.to_r
      @tempo_computer = Musicality::TempoComputer.new Event.hash_events_by_offset([tempo])
      sample_rate = 48
      @converter = Musicality::NoteTimeConverter.new @tempo_computer, sample_rate
    end

    it "should return a time of zero when note end is zero." do
      @converter.time_elapsed(0.to_r).should eq(0.to_r)
    end
    
    it "should return a time of 1 second when note end is equal to the initial notes-per-second" do
      note_end = @tempo_computer.notes_per_second_at(0.to_r)
      @converter.time_elapsed(note_end).should eq(1.to_r)
    end
  end
  
  context "linear tempo-change" do
    before :each do 
      tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25.to_r, :offset => 0.to_r
      tempo2 = Musicality::Tempo.new :beats_per_minute => 60, :beat_duration => 0.25.to_r, :offset => 1.to_r, :duration => 1.to_r
      
      tempo_computer = Musicality::TempoComputer.new Event.hash_events_by_offset([tempo, tempo2])
      sample_rate = 48
      @converter = Musicality::NoteTimeConverter.new tempo_computer, sample_rate
    end

    it "should return a time of zero when note end is zero." do
      @converter.time_elapsed(0.to_r).should eq(0.to_r)
    end

    it "should return a time of 2 sec during a 1-note long transition from 120bpm to 60bpm" do
      @converter.time_elapsed(2.to_r, 1.to_r).should eq(2.to_r)
    end

  end
  
end
