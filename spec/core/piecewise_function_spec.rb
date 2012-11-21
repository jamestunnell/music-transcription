require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::PiecewiseFunction do
  
  before :each do
    @pwf = Musicality::PiecewiseFunction.new
  end
  it "should have no pieces by default" do
    @pwf.pieces.should be_empty
  end

  it "should be able to add a piece" do
    @pwf.add_piece 0...2, lambda {|x| x }
    @pwf.pieces.count.should be 1
    @pwf.pieces[0...2].should be
    @pwf.pieces[0...2].should eq(lambda {|x| x})
  end
  
  it "should be able to evaluate a piece" do
    @pwf.add_piece 0...2, lambda {|x| x }
    @pwf.evaluate_at(1.5).should eq(1.5)
  end
  
  it "should not be able to evaluate where there is no piece" do
    @pwf.add_piece 0...2, lambda {|x| x }
    @pwf.evaluate_at(-0.1).should be_nil
    @pwf.evaluate_at(2).should be_nil
  end
  
  it "should be able to add non-overlapping pieces and evaluate them seperately" do
    @pwf.add_piece 0...2, lambda {|x| x }
    @pwf.add_piece 2...4, lambda {|x| 2 * x }
    @pwf.evaluate_at(1).should eq(1)
    @pwf.evaluate_at(3).should eq(6)
  end

  it "should be able to add overlapping pieces and evaluate them seperately" do
    @pwf.add_piece 0...10, lambda {|x| x * 2 }
    @pwf.add_piece 20...80, lambda {|x| x * 3 }
    @pwf.add_piece 90...100, lambda {|x| x * 4 }
    
    @pwf.add_piece 5...15, lambda {|x| x * 5 }
    @pwf.add_piece 45...55, lambda {|x| x * 6 }
    @pwf.add_piece 85...95, lambda {|x| x * 7 }
    
    {
      1 => 2, #1...5 should be x * 2
      4 => 8, #1...5 should be x * 2
      5 => 25, #5...15 should be x * 5      
      20 => 60, #20...45 should be x * 3
      44 => 132, #20...45 should be x * 3
      45 => 270, #45...55 should be x * 6
      54 => 324, #45...55 should be x * 6
      55 => 165, #55...80 should be x * 3
      79 => 237, #55...80 should be x * 3
      85 => 595, #85...95 should be x * 7
      94 => 658, #85...95 should be x * 7
      95 => 380, #95...100 should be x * 4
      99 => 396, #95...100 should be x * 4
      
    }.each do |x,y|
      @pwf.evaluate_at(x).should eq(y)
    end
  end

end
