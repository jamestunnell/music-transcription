require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Pitch do

  before :each do
    @cases = 
    [
      { octave: 1, semitone: 0, :ratio => 2.0, :total_semitone => 12 },
      { octave: 2, semitone: 0, :ratio => 4.0, :total_semitone => 24 },
      { octave: 1, semitone: 6, :ratio => 2.828, :total_semitone => 18 },
      { octave: 2, semitone: 6, :ratio => 5.657, :total_semitone => 30 },
      { octave: 3, semitone: 7, :ratio => 11.986, :total_semitone => 43 },
      { octave: -1, semitone: 0, :ratio => 0.5, :total_semitone => -12 },
      { octave: -2, semitone: 0, :ratio => 0.25, :total_semitone => -24 },
      { octave: -2, semitone: 7, :ratio => 0.375, :total_semitone => -17 },
      { octave: -1, semitone: 9, :ratio => 0.841, :total_semitone => -3 },
    ]
  end
  
  it "should be constructible with no parameters (no error raised)" do
	  lambda { Pitch.new }.should_not raise_error
  end
  
  it "should be hash-makeable" do
    obj = Pitch.new octave: 4, semitone: 3
    obj.octave.should eq(4)
    obj.semitone.should eq(3)
  end
  
  it "should use default octave and semitone if none is given" do
    p = Pitch.new
    p.ratio.should be_within(0.01).of(1.0)
    p.total_semitone.should eq(0)
  end
  
  it "should use the octave and semitone given during construction" do
    @cases.each do |case_data|
      p = Pitch.new octave: case_data[:octave], semitone: case_data[:semitone]
      p.ratio.should be_within(0.01).of case_data[:ratio]
      p.total_semitone.should be case_data[:total_semitone]
    end
  end

  it "should allow setting by ratio" do
    @cases.each do |case_data|
      p = Pitch.new
      p.ratio = case_data[:ratio]
            
      p.octave.should eq case_data[:octave]
      p.semitone.should eq case_data[:semitone]
      p.total_semitone.should eq case_data[:total_semitone]
    end
  end

  it "should setting by total_semitone" do    
    @cases.each do |case_data|
      p = Pitch.new
      p.total_semitone = case_data[:total_semitone] 
      
      p.octave.should eq case_data[:octave]
      p.semitone.should eq case_data[:semitone]
      p.total_semitone.should eq case_data[:total_semitone]
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
  
  describe 'String#to_pitch' do
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
  
  describe '.make_from_freq' do
    it 'should make a pitch whose freq is approximately the given freq' do
      [16.35, 440.0, 987.77].each do |given_freq|
	pitch = Pitch.make_from_freq given_freq
	pitch.freq.should be_within(0.01).of(given_freq)
      end
    end
  end
  
  describe '.make_from_semitone' do
    context 'given an integer less than 12' do
      before(:all) { @pitch = Pitch.make_from_semitone(11) }
      
      it 'semitone should equal given integer' do
	@pitch.semitone.should eq 11
      end
    end
  end
end
