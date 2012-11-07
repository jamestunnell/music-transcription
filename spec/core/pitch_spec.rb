require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Pitch do

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
  
  it "should be hash-makeable" do
    Musicality::HashMakeUtil.is_hash_makeable?(Musicality::Pitch).should be_true
  
    hash = { :octave => 4, :semitone => 3 }
    obj = Musicality::Pitch.make_from_hash hash
    hash2 = obj.save_to_hash
    
    hash.should eq(hash2)
    
    obj2 = Musicality::Pitch.make_from_hash hash2
    
    obj.octave.should eq(obj2.octave)
    obj.semitone.should eq(obj2.semitone)
    obj.cent.should eq(obj2.cent)
  end
  
  it "should use default octave, semitone, and cent in none is given" do
    p = Musicality::Pitch.new
    p.ratio.should be_within(0.01).of(1.0)
    p.total_cent.should eq(0)
  end
  
  it "should use the octave, semitone, and cent given during construction" do
    @cases.each do |case_data|
      p = Musicality::Pitch.new :octave => case_data[:octave], :semitone => case_data[:semitone], :cent => case_data[:cent]
      p.ratio.should be_within(0.01).of case_data[:ratio]
      p.total_cent.should be case_data[:total_cent]
    end
  end

  it "should allow setting by ratio" do
    @cases.each do |case_data|
      p = Musicality::Pitch.new
      p.ratio = case_data[:ratio]
            
      p.octave.should eq case_data[:octave]
      p.semitone.should eq case_data[:semitone]
      p.cent.should eq case_data[:cent]
      p.total_cent.should eq case_data[:total_cent]
    end
  end

  it "should setting by total_cent" do    
    @cases.each do |case_data|
      p = Musicality::Pitch.new
      p.total_cent = case_data[:total_cent] 
      
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
    
    p1.should be < p2
    p1.should be < p3
    p2.should be < p3
    p3.should be > p2
    p3.should be > p1
    p2.should be > p1
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
  
  it "should have freq of 440 for A4" do
    a4 = Musicality::Pitch.new :octave => 4, :semitone => 9
    a4.freq.should be_within(0.01).of(440.0)
  end
end
