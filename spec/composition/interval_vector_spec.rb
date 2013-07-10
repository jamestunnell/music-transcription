require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::IntervalVector do
  describe '.new' do
    it 'should raise ArgumentError if no intervals are given' do
      lambda { IntervalVector.new([]) }.should raise_error(ArgumentError)
    end
    
    it 'should assign given intervals' do
      intervals = [1,2,3]
      scale = IntervalVector.new(intervals)
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
        IntervalVector.new([0,1,2]),
        IntervalVector.new([0,2,4,5,7,8]),
        IntervalVector.new([12,8,4,2,1]),
        IntervalVector.new([-4,-2,0,2,4]),
        IntervalVector.new([10,-10,-1,1,-1]),
        IntervalVector.new([0,11,0]),
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
    
    it 'should create pitches that are relative to previous pitches' do
      @scales.each do |scale|
        @base_pitches.each do |base_pitch|
          pitches = scale.to_pitches base_pitch
          prev_pitch = base_pitch
          pitches.each_index do |i|
            diff = pitches[i] - prev_pitch
            diff.total_semitone.should eq scale.intervals[i]
            prev_pitch = pitches[i]
          end
        end
      end
    end
  end
end
