require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pitch do

  before :each do
    @cases = 
    [
      { octave: 1, semitone: 0, cent: 0, :ratio => 2.0, :total_cent => 1200 },
      { octave: 2, semitone: 0, cent: 0, :ratio => 4.0, :total_cent => 2400 },
      { octave: 1, semitone: 6, cent: 0, :ratio => 2.8284, :total_cent => 1800 },
      { octave: 2, semitone: 6, cent: 0, :ratio => 5.6569, :total_cent => 3000 },
      { octave: 1, semitone: 6, cent: 20, :ratio => 2.8613, :total_cent => 1820 },
      { octave: 2, semitone: 6, cent: 20, :ratio => 5.7226, :total_cent => 3020 },
      { octave: 3, semitone: 7, cent: 77, :ratio => 12.5316, :total_cent => 4377 },
      { octave: -1, semitone: 0, cent: 0, :ratio => 0.5, :total_cent => -1200 },
      { octave: -2, semitone: 0, cent: 0, :ratio => 0.25, :total_cent => -2400 },
      { octave: -2, semitone: 7, cent: 55, :ratio => 0.3867, :total_cent => -1645 },
      { octave: -1, semitone: 9, cent: 23, :ratio => 0.8521, :total_cent => -277 },
    ]
  end
  
  it "should be constructible with no parameters (no error raised)" do
	  lambda { Pitch.new }.should_not raise_error
  end
  
  it "should be hash-makeable" do
    obj = Pitch.new octave: 4, semitone: 3
    obj.octave.should eq(4)
    obj.semitone.should eq(3)
    obj.cent.should eq(0)
  end
  
  it "should use default octave, semitone, and cent in none is given" do
    p = Pitch.new
    p.ratio.should be_within(0.01).of(1.0)
    p.total_cent.should eq(0)
  end
  
  it "should use the octave, semitone, and cent given during construction" do
    @cases.each do |case_data|
      p = Pitch.new octave: case_data[:octave], semitone: case_data[:semitone], cent: case_data[:cent]
      p.ratio.should be_within(0.01).of case_data[:ratio]
      p.total_cent.should be case_data[:total_cent]
    end
  end

  it "should allow setting by ratio" do
    @cases.each do |case_data|
      p = Pitch.new
      p.ratio = case_data[:ratio]
            
      p.octave.should eq case_data[:octave]
      p.semitone.should eq case_data[:semitone]
      p.cent.should eq case_data[:cent]
      p.total_cent.should eq case_data[:total_cent]
    end
  end

  it "should setting by total_cent" do    
    @cases.each do |case_data|
      p = Pitch.new
      p.total_cent = case_data[:total_cent] 
      
      p.octave.should eq case_data[:octave]
      p.semitone.should eq case_data[:semitone]
      p.cent.should eq case_data[:cent]
      p.total_cent.should eq case_data[:total_cent]
    end
  end
  
  it "should be comparable to other pitches" do
    p1 = Pitch.new semitone: 1
    p2 = Pitch.new semitone: 2
    p3 = Pitch.new semitone: 3

    p1.should eq(Pitch.new semitone: 1)
    p2.should eq(Pitch.new semitone: 2)
    p3.should eq(Pitch.new semitone: 3)
    
    p1.should be < p2
    p1.should be < p3
    p2.should be < p3
    p3.should be > p2
    p3.should be > p1
    p2.should be > p1
  end

  it "should be addable and subtractable with other pitches" do
    p1 = Pitch.new semitone: 1
    p2 = Pitch.new semitone: 2
    p3 = Pitch.new semitone: 3
    
    (p1 + p2).should eq(Pitch.new semitone: 3) 
    (p1 + p3).should eq(Pitch.new semitone: 4)
    (p2 + p3).should eq(Pitch.new semitone: 5)
    
    (p1 - p2).should eq(Pitch.new semitone: -1) 
    (p1 - p3).should eq(Pitch.new semitone: -2)
    (p2 - p3).should eq(Pitch.new semitone: -1)
    (p3 - p2).should eq(Pitch.new semitone: 1)
    (p3 - p1).should eq(Pitch.new semitone: 2)
  end
  
  it "should have freq of 440 for A4" do
    a4 = Pitch.new octave: 4, semitone: 9
    a4.freq.should be_within(0.01).of(440.0)
  end
  
  context 'String#to_pitch' do
    it 'should create a Pitch object that matches the musical note' do
      {
	"Ab2" => Pitch.new(octave: 2, semitone: 8),
	"C0" => Pitch.new(octave: 0, semitone: 0),
	"db4" => Pitch.new(octave: 4, semitone: 1),
	"F#12" => Pitch.new(octave: 12, semitone: 6),
	"E#7" => Pitch.new(octave: 7, semitone: 5),
	"G9" => Pitch.new(octave: 9, semitone: 7),
	"Bb10" => Pitch.new(octave: 10, semitone: 10),
      }.each do |str, expected_pitch|
	str.to_pitch.should eq(expected_pitch)
      end
    end
  end
  
  context '.make_from_freq' do
    it 'should make a pitch whose freq is approximately the given freq' do
      one_cent = Pitch.new(cent: 1)
      [1.0, 25.0, 200.0, 3500.0].each do |given_freq|
	pitch = Pitch.make_from_freq given_freq
	freq = pitch.freq
	if freq > given_freq
	  (freq / given_freq).should be < one_cent.ratio
	elsif freq < given_freq
	  (given_freq / freq).should be < one_cent.ratio
	end
      end
    end
  end
end
