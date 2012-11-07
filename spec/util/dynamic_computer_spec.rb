require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::DynamicComputer do
  before :all do
    @dynamic1 = Musicality::Dynamic.new :offset => 0.0, :loudness => 0.2
    @dynamic2 = Musicality::Dynamic.new :offset => 1.0, :loudness => 0.6
    @dynamic3 = Musicality::Dynamic.new :offset => 1.0, :loudness => 0.6, :duration => 1.0
  end
  
  describe "constant dynamic" do
    before :each do
      @dyn_comp = Musicality::DynamicComputer.new @dynamic1
    end
    
    it "should always return starting tempo if only tempo given" do
      [Musicality::Event::MIN_OFFSET, -1000, 0, 1, 5, 100, 10000, Musicality::Event::MAX_OFFSET].each do |offset|
        @dyn_comp.loudness_at(offset).should eq(0.2)
      end
    end
  end
  
  describe "two dynamic, no transition" do
    before :each do
      @dyn_comp = Musicality::DynamicComputer.new @dynamic1, [@dynamic2]
    end
    
    it "should be the first (starting) dynamic just before the second dynamic" do
      @dyn_comp.loudness_at(0.999).should eq(0.2)
    end
        
    it "should transition to the second tempo immediately" do
      @dyn_comp.loudness_at(1.0).should eq(0.6)
    end

    it "should be the first tempo for all time before" do
      @dyn_comp.loudness_at(Musicality::Event::MIN_OFFSET).should eq(0.2)
    end
    
    it "should be at the second tempo for all time after" do
      @dyn_comp.loudness_at(Musicality::Event::MAX_OFFSET).should eq(0.6)
    end
  end
  
  context "two dynamics, linear transition" do
    before :each do
      @dyn_comp = Musicality::DynamicComputer.new @dynamic1, [@dynamic3]
    end
    
    it "should be the first (starting) tempo just before the second tempo" do
      @dyn_comp.loudness_at(0.999).should eq(0.2)
    end
        
    it "should be the first (starting) tempo exactly at the second tempo" do
      @dyn_comp.loudness_at(1.0).should eq(0.2)
    end

    it "should be 1/4 to the second tempo after 1/4 transition duration has elapsed" do
      @dyn_comp.loudness_at(Rational(5,4).to_f).should eq(0.3)
    end

    it "should be 1/2 to the second tempo after 1/2 transition duration has elapsed" do
      @dyn_comp.loudness_at(Rational(6,4).to_f).should eq(0.4)
    end

    it "should be 3/4 to the second tempo after 3/4 transition duration has elapsed" do
      @dyn_comp.loudness_at(Rational(7,4).to_f).should eq(0.5)
    end

    it "should be at the second tempo after transition duration has elapsed" do
      @dyn_comp.loudness_at(Rational(8,4).to_f).should eq(0.6)
    end
  end

end

