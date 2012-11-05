require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Program do
  
  it "should default values for start, markers, and jumps" do
    program = Musicality::Program.new :stop => 35.0
    program.start.should eq(0.0)
    program.markers.should be_empty
    program.jumps.should be_empty
  end
  
  it "should assign the start given during initialization" do
    program = Musicality::Program.new :start => 1.0, :stop => 35.0
    program.start.should eq(1.0)
  end

  it "should assign the start given during initialization" do
    markers = { :a => 10.0, :b => 25.0 }
    program = Musicality::Program.new :stop => 35.0, :markers => markers
    program.markers.should eq(markers.clone)
  end

  it "should assign the jumps given during initialization" do
    jumps = [ { :at => :a, :to => 10.0 }, { :at => 15.0, :to => 10.0 } ]
    program = Musicality::Program.new :stop => 35.0, :jumps => jumps
    program.jumps.should eq(jumps.clone)
  end

  describe "#valid?" do
    it "should return true if all jump offsets are reachable" do
      markers = { :a => 10.0, :b => 25.0 }
      jumps = [ { :at => :a, :to => 0.0 }, { :at => 15.0, :to => :b } ]
      program = Musicality::Program.new :stop => 35.0, :markers => markers, :jumps => jumps
      program.valid?().should be_true
    end

    it "should return false if some jump offsets are not reachable" do
      markers = { :a => 10.0, :b => 25.0 }
      jumps = [ { :at => :a, :to => 30.0 }, { :at => :b, :to => 0.0 } ]
      program = Musicality::Program.new :stop => 35.0, :markers => markers, :jumps => jumps
      program.valid?().should be_false
    end
    
    it "should return false if any markers used in jumps are note defined" do
      markers = { :a => 10.0, :b => 25.0 }
      jumps = [ { :at => :a, :to => 30.0 }, { :at => :c, :to => 0.0 } ]
      program = Musicality::Program.new :stop => 35.0, :markers => markers, :jumps => jumps
      program.valid?().should be_false
    end
  end
  
  describe "#include" do
    it "should return true for any offset which would be encountered" do
      markers = { :a => 10.0, :b => 25.0 }
      jumps = [ { :at => :a, :to => 0.0 }, { :at => :b, :to => 30.0 } ]
      program = Musicality::Program.new :stop => 35.0, :markers => markers, :jumps => jumps
      
      [0.0, 7.0, 11.0, 20.0, 25.0].each do |offset|
        program.include?(offset).should be_true
      end
    end

    it "should return false for any offset which would not be encountered" do
      markers = { :a => 10.0, :b => 25.0 }
      jumps = [ { :at => :a, :to => 0.0 }, { :at => :b, :to => 30.0 } ]
      program = Musicality::Program.new :stop => 35.0, :markers => markers, :jumps => jumps
      
      [-0.1, 25.1, 29.9].each do |offset|
        program.include?(offset).should be_false
      end
    end
  end
  
  describe "#jumps_left_at" do
    before :each do
      @markers = { :a => 10.0, :b => 15.0, :c => 20.0 }
      @jumps = [ { :at => :a, :to => 0.0 }, { :at => :b, :to => :c } ]
      @program = Musicality::Program.new :stop => 25.0, :markers => @markers, :jumps => @jumps
    end
    
    it "should return all jumps when offset given is start offset" do
      @program.jumps_left_at(@program.start).count.should eq(@jumps.count)
    end

    it "should return all jumps when offset given is between start and first jump" do
      @program.jumps_left_at(5.0).count.should eq(@jumps.count)
    end

    it "should return all but first jump when offset given is just before second jump" do
      @program.jumps_left_at(14.9).count.should eq(@jumps.count - 1)
    end
    
    it "should return no jumps when offset given is past last jump[:to]" do
      @program.jumps_left_at(20.1).count.should eq(0)
    end
  end
end
