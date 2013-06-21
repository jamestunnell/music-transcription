require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Scale do
  describe '.new' do
    it 'should raise ArgumentError if no intervals are given' do
      lambda { Scale.new([]) }.should raise_error(ArgumentError)
    end
    
    it 'should assign given intervals' do
      intervals = [1,2,3]
      scale = Scale.new(intervals)
      scale.intervals.should eq(intervals)
    end
  end
  
  describe '#to_pitches' do
    before :all do
      @base_pitches = [
        Pitch.new(:octave => 2, :semitone => 1),
        Pitch.new(:octave => 7, :semitone => 7),
        Pitch.new(:octave => 4, :semitone => 11),
      ]
      
      @scales = [
        Scale.new([0,1,2]),
        Scale.new([0,2,4,5,7,8]),
        Scale.new([12,8,4,2,1]),
        Scale.new([0,11,0]),
      ]
    end

    it 'should create the same number of pitches as there are scale intervals' do
      @scales.each do |scale|
        @base_pitches.each do |base_pitch|
          pitches = scale.to_pitches base_pitch
          pitches.count.should eq scale.intervals.count
        end
      end
    end
    
    it 'should create pitches that are relative to the given base pitch' do
      @scales.each do |scale|
        @base_pitches.each do |base_pitch|
          pitches = scale.to_pitches base_pitch
          pitches.each_index do |i|
            diff = pitches[i] - base_pitch
            diff.total_semitone.should eq scale.intervals[i]
          end
        end
      end
    end
  end
end
