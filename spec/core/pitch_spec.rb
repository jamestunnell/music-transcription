require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Pitch do

  RSpec::Matchers.define :be_almost do |expected|
    match do |actual|
      (actual - expected).abs < 0.01
    end
  end
  
  RSpec::Matchers.define :be_less_than do |expected|
    match do |actual|
      actual < expected
    end
  end
  
  RSpec::Matchers.define :be_more_than do |expected|
    match do |actual|
      actual > expected
    end
  end
    
  it "should be constructible with no parameters (no ArgumentError raised)" do
	  lambda { Musicality::Pitch.new }.should_not raise_error ArgumentError
  end
  
  it "should use default octave, semitone, and cent in none is given" do
    p = Musicality::Pitch.new
    p.ratio.should be_almost(1.0)
    p.total_cent.should eq(0)
  end
  
  it "should use the octave, semitone, and cent given" do
    cases = 
    { 
      [1,0,0] => { :ratio => 2.0, :total_cent => 1200 },
      [2,0,0] => { :ratio => 4.0, :total_cent => 2400 },
      [1,6,0] => { :ratio => 2.8284, :total_cent => 1800 },
      [2,6,0] => { :ratio => 5.6569, :total_cent => 3000 },
      [1,6,20] => { :ratio => 2.8613, :total_cent => 1820 },
      [2,6,20] => { :ratio => 5.7226, :total_cent => 3020 },
      [3,7,77] => { :ratio => 12.5316, :total_cent => 4377 },
      [-1,0,0] => { :ratio => 0.5, :total_cent => -1200 },
      [-2,0,0] => { :ratio => 0.25, :total_cent => -2400 },
      [-2,7,55] => { :ratio => 0.3867, :total_cent => -1645 },
      [1,-14,-77] => { :ratio => 0.8521, :total_cent => -277 },
    }
    
    cases.each do |input, expected|
      p = Musicality::Pitch.new :octave => input[0], :semitone => input[1], :cent => input[2]
      p.ratio.should be_almost(expected[:ratio])
      p.total_cent.should be expected[:total_cent]
    end
  end
  
  it "should be comparable to other pitches" do
    p1 = Musicality::Pitch.new :semitone => 1
    p2 = Musicality::Pitch.new :semitone => 2
    p3 = Musicality::Pitch.new :semitone => 3

    p1.should eq(Musicality::Pitch.new :semitone => 1)
    p2.should eq(Musicality::Pitch.new :semitone => 2)
    p3.should eq(Musicality::Pitch.new :semitone => 3)
    
    p1.should be_less_than p2
    p1.should be_less_than p3
    p2.should be_less_than p3
    p3.should be_more_than p2
    p3.should be_more_than p1
    p2.should be_more_than p1
  end

  it "should be addable and subtractable with other pitches" do
    p1 = Musicality::Pitch.new :semitone => 1
    p2 = Musicality::Pitch.new :semitone => 2
    p3 = Musicality::Pitch.new :semitone => 3
    
    (p1 + p2).should eq(Musicality::Pitch.new :semitone => 3) 
    (p1 + p3).should eq(Musicality::Pitch.new :semitone => 4)
    (p2 + p3).should eq(Musicality::Pitch.new :semitone => 5)
    
    (p1 - p2).should eq(Musicality::Pitch.new :semitone => -1) 
    (p1 - p3).should eq(Musicality::Pitch.new :semitone => -2)
    (p2 - p3).should eq(Musicality::Pitch.new :semitone => -1)
    (p3 - p2).should eq(Musicality::Pitch.new :semitone => 1)
    (p3 - p1).should eq(Musicality::Pitch.new :semitone => 2)
  end
end
