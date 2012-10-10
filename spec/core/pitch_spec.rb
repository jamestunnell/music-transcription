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
  
  before :each do
    @cases = 
    [
      { :octave => 1, :semitone => 0, :cent => 0, :ratio => 2.0, :total_cent => 1200 },
      { :octave => 2, :semitone => 0, :cent => 0, :ratio => 4.0, :total_cent => 2400 },
      { :octave => 1, :semitone => 6, :cent => 0, :ratio => 2.8284, :total_cent => 1800 },
      { :octave => 2, :semitone => 6, :cent => 0, :ratio => 5.6569, :total_cent => 3000 },
      { :octave => 1, :semitone => 6, :cent => 20, :ratio => 2.8613, :total_cent => 1820 },
      { :octave => 2, :semitone => 6, :cent => 20, :ratio => 5.7226, :total_cent => 3020 },
      { :octave => 3, :semitone => 7, :cent => 77, :ratio => 12.5316, :total_cent => 4377 },
      { :octave => -1, :semitone => 0, :cent => 0, :ratio => 0.5, :total_cent => -1200 },
      { :octave => -2, :semitone => 0, :cent => 0, :ratio => 0.25, :total_cent => -2400 },
      { :octave => -2, :semitone => 7, :cent => 55, :ratio => 0.3867, :total_cent => -1645 },
      { :octave => -1, :semitone => 9, :cent => 23, :ratio => 0.8521, :total_cent => -277 },
    ]
  end
  
  it "should be constructible with no parameters (no ArgumentError raised)" do
	  lambda { Musicality::Pitch.new }.should_not raise_error ArgumentError
  end
  
  it "should use default octave, semitone, and cent in none is given" do
    p = Musicality::Pitch.new
    p.ratio.should be_almost(1.0)
    p.total_cent.should eq(0)
  end
  
  it "should use the octave, semitone, and cent given during construction" do
    @cases.each do |case_data|
      p = Musicality::Pitch.new :octave => case_data[:octave], :semitone => case_data[:semitone], :cent => case_data[:cent]
      p.ratio.should be_almost case_data[:ratio]
      p.total_cent.should be case_data[:total_cent]
    end
  end

  it "should use the ratio given during construction" do
    @cases.each do |case_data|
      p = Musicality::Pitch.new :ratio => case_data[:ratio]
            
      p.octave.should eq case_data[:octave]
      p.semitone.should eq case_data[:semitone]
      p.cent.should eq case_data[:cent]
      p.total_cent.should eq case_data[:total_cent]
    end
  end

  it "should use the total_cent given during construction" do    
    @cases.each do |case_data|
      p = Musicality::Pitch.new :total_cent => case_data[:total_cent] 
      
      p.octave.should eq case_data[:octave]
      p.semitone.should eq case_data[:semitone]
      p.cent.should eq case_data[:cent]
      p.total_cent.should eq case_data[:total_cent]
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
