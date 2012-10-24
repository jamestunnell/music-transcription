require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::TempoComputer do
  
  before :each do
    @tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0
  end

  it "should raise error if no tempos are given" do
    lambda { Musicality::TempoComputer.new({}) }.should raise_error ArgumentError
  end

  it "should raise error if no starting tempo (offset 0) is given" do
    tempo = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25, :offset => 1.0
    lambda { Musicality::TempoComputer.new({ 1.0 => tempo}) }.should raise_error ArgumentError
  end

  it "should not raise error if a starting tempo (offset 0) is given" do
    
    lambda { Musicality::TempoComputer.new({ 0.0 => @tempo }) }.should_not raise_error ArgumentError
  end

  it "should always return starting tempo if only tempo given" do
    tc = Musicality::TempoComputer.new 0.0 => @tempo
    [0, 1, 5, 100, 10000, Musicality::Note::MAX_OFFSET].each do |offset|
      tc.notes_per_second_at(offset).should eq(0.5)
    end
  end

  it "should return nil if offset is past max" do
    tc = Musicality::TempoComputer.new 0.0 => @tempo
    tc.notes_per_second_at(Musicality::Note::MAX_OFFSET + 1).should be_nil
  end

  context "two tempos, no transition" do
    before :each do
      tempo1 = Musicality::Tempo.new :beats_per_minute => 120, :beat_duration => 0.25, :offset => 0.0
      tempo2 = Musicality::Tempo.new :beats_per_minute => 60, :beat_duration => 0.25, :offset => 1.0
      @tc = Musicality::TempoComputer.new Event.hash_events_by_offset [tempo1, tempo2]
    end

    it "should be the first (starting) tempo just before the second tempo" do
      @tc.notes_per_second_at(0.999).should eq(0.5)
    end
        
    it "should transition to the second tempo immediately" do
      @tc.notes_per_second_at(1).should eq(0.25)
    end
    
    it "should be at the second tempo for all time after" do
      @tc.notes_per_second_at(Musicality::Note::MAX_OFFSET).should eq(0.25)
    end
  end

  context "two tempos, linear transition" do
    before :each do
      tempo1 = Musicality::Tempo.new :beats_per_minute => 120.0, :beat_duration => 0.25, :offset => 0.0
      tempo2 = Musicality::Tempo.new :beats_per_minute => 60.0, :beat_duration => 0.25, :offset => 1.0, :duration => 1.0

      @tc = Musicality::TempoComputer.new Event.hash_events_by_offset([tempo1, tempo2])
    end

    it "should be the first (starting) tempo just before the second tempo" do
      @tc.notes_per_second_at(0.999).should eq(0.5)
    end
        
    it "should be the first (starting) tempo exactly at the second tempo" do
      @tc.notes_per_second_at(1.0).should eq(0.5)
    end

    it "should be 1/4 to the second tempo after 1/4 transition duration has elapsed" do
      @tc.notes_per_second_at(Rational(5,4).to_f).should eq(Rational(7,16).to_f)
    end

    it "should be 1/2 to the second tempo after 1/2 transition duration has elapsed" do
      @tc.notes_per_second_at(Rational(6,4).to_f).should eq(Rational(3,8).to_f)
    end

    it "should be 3/4 to the second tempo after 3/4 transition duration has elapsed" do
      @tc.notes_per_second_at(Rational(7,4).to_f).should eq(Rational(5,16).to_f)
    end

    it "should be at the second tempo after transition duration has elapsed" do
      @tc.notes_per_second_at(Rational(8,4).to_f).should eq(0.25)
    end
  end
end
