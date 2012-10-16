require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::TempoComputer do
  
  before :each do
    @tempo1 = Musicality::Tempo.new(120, 0.25.to_r)

  end

  it "should raise error if no tempos are given" do
    lambda { Musicality::TempoComputer.new {} }.should raise_error ArgumentError
  end

  it "should raise error if no starting tempo (offset 0) is given" do
    lambda { Musicality::TempoComputer.new({ 1.to_r => @tempo1 }) }.should raise_error ArgumentError
  end

  it "should not raise error if a starting tempo (offset 0) is given" do
    lambda { Musicality::TempoComputer.new({ 0.to_r => @tempo1 }) }.should_not raise_error ArgumentError
  end

  it "should always return starting tempo if only tempo given" do
    tc = Musicality::TempoComputer.new 0.to_r => @tempo1
    [0, 1, 5, 100, 10000, Musicality::TempoComputer::MAX_NOTE_OFFSET].each do |offset|
      tc.notes_per_second_at(offset).should eq(0.5.to_r)
    end
  end

  it "should return nil if offset is past max" do
    tc = Musicality::TempoComputer.new 0.to_r => @tempo1
    tc.notes_per_second_at(Musicality::TempoComputer::MAX_NOTE_OFFSET + 1).should be_nil
  end

  context "two tempos, no transition" do
    before :each do
      @tempo2 = Musicality::Tempo.new(60, 0.25.to_r)
      @tempos = { 0.to_r => @tempo1, 1.to_r => @tempo2 }
      @tc = Musicality::TempoComputer.new @tempos
    end

    it "should be the first (starting) tempo just before the second tempo" do
      @tc.notes_per_second_at(0.999.to_r).should eq(0.5)
    end
        
    it "should transition to the second tempo immediately" do
      @tc.notes_per_second_at(1.to_r).should eq(0.25)
    end
    
    it "should be at the second tempo for all time after" do
      @tc.notes_per_second_at(Musicality::TempoComputer::MAX_NOTE_OFFSET).should eq(0.25)
    end
  end

  context "two tempos, linear transition" do
    before :each do
      @tempo2 = Musicality::Tempo.new(60, 0.25.to_r, 1.to_r)
      @tempos = { 0.to_r => @tempo1, 1.to_r => @tempo2 }
      @tc = Musicality::TempoComputer.new @tempos
    end

    it "should be the first (starting) tempo just before the second tempo" do
      @tc.notes_per_second_at(0.999.to_r).should eq(0.5)
    end
        
    it "should be the first (starting) tempo exactly at the second tempo" do
      @tc.notes_per_second_at(1.to_r).should eq(0.5)
    end

    it "should be 1/4 to the second tempo after 1/4 transition duration has elapsed" do
      @tc.notes_per_second_at(Rational(5,4)).should eq(Rational(7,16))
    end

    it "should be 1/2 to the second tempo after 1/2 transition duration has elapsed" do
      @tc.notes_per_second_at(Rational(6,4)).should eq(Rational(3,8))
    end

    it "should be 3/4 to the second tempo after 3/4 transition duration has elapsed" do
      @tc.notes_per_second_at(Rational(7,4)).should eq(Rational(5,16))
    end

    it "should be at the second tempo after transition duration has elapsed" do
      @tc.notes_per_second_at(Rational(8,4)).should eq(0.25)
    end
  end
end
