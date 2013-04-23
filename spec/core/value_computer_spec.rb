require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::ValueComputer do
  before :all do
    @value_change1 = value_change(1.0, 0.6)
    @value_change2 = value_change(1.0, 0.6, linear(1.0))
  end
  
  describe "constant value" do
    before :each do
      @comp = Musicality::ValueComputer.new SettingProfile.new(:start_value => 0.5)
    end
    
    it "should always return default value if no changes are given" do
      [ValueComputer.domain_min, -1000, 0, 1, 5, 100, 10000, ValueComputer.domain_max].each do |offset|
        @comp.value_at(offset).should eq(0.5)
      end
    end
  end
  
  describe "one change, no transition" do
    before :each do
      setting_profile = SettingProfile.new :start_value => 0.5, :value_changes => [@value_change1]
      @comp = Musicality::ValueComputer.new setting_profile
    end
    
    it "should be the default value just before the first change" do
      @comp.value_at(0.999).should eq(0.5)
    end
        
    it "should transition to the second value immediately" do
      @comp.value_at(1.0).should eq(0.6)
    end

    it "should be the first value for all time before" do
      @comp.value_at(ValueComputer.domain_min).should eq(0.5)
    end
    
    it "should be at the second value for all time after" do
      @comp.value_at(ValueComputer.domain_max).should eq(0.6)
    end
  end
  
  context "one change, linear transition" do
    before :each do
      setting_profile = SettingProfile.new :start_value => 0.2, :value_changes => [@value_change2]
      @comp = Musicality::ValueComputer.new setting_profile
    end
    
    it "should be the first (starting) value just before the second value" do
      @comp.value_at(0.999).should eq(0.2)
    end
        
    it "should be the first (starting) value exactly at the second value" do
      @comp.value_at(1.0).should eq(0.2)
    end
  
    it "should be 1/4 to the second value after 1/4 transition duration has elapsed" do
      @comp.value_at(Rational(5,4).to_f).should eq(0.3)
    end
  
    it "should be 1/2 to the second value after 1/2 transition duration has elapsed" do
      @comp.value_at(Rational(6,4).to_f).should eq(0.4)
    end
  
    it "should be 3/4 to the second value after 3/4 transition duration has elapsed" do
      @comp.value_at(Rational(7,4).to_f).should eq(0.5)
    end
  
    it "should be at the second value after transition duration has elapsed" do
      @comp.value_at(Rational(8,4).to_f).should eq(0.6)
    end
  end

end

