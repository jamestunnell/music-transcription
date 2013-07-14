require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PitchClassSet do
  describe '.new' do
    context 'nothing given' do
      it 'should not raise an error' do
        lambda { PitchClassSet.new([]) }.should_not raise_error
      end
    end

    context 'pitch classes (Fixnum) given' do
      it 'should use the given pitch class' do
        10.times do
          pitch_classes = Array.new(rand(0..10)) { rand(0..8) }
          pcs = PitchClassSet.new pitch_classes
          pitch_classes.each do |pitch_class|
            pcs.include? pitch_class
          end
        end
      end
    end
    
    context 'Pitch objects given' do
      it 'should use the pitch semitone to determine pitch class' do
        10.times do
          pitches = Array.new(rand(0..10)) {
            Pitch.new(:octave => rand(0..8), :semitone => rand(0..8))
          }
          
          pcs = PitchClassSet.new pitches
          
          pitches.each do |pitch|
            pcs.include? pitch.semitone
          end
        end
      end
    end
    
    context 'Pitch objects and pitch classes (Fixnum) given' do
      it 'should use the pitch semitone to determine pitch class' do
        10.times do
          pitches = Array.new(rand(0..10)) {
            Pitch.new(:octave => rand(0..8), :semitone => rand(0..8))
          }
          pitch_classes = Array.new(rand(0..10)) { rand(0..8) }
          
          pcs = PitchClassSet.new pitches + pitch_classes
          
          pitches.each do |pitch|
            pcs.include? pitch.semitone
          end
          pitch_classes.each do |pitch_class|
            pcs.include? pitch_class
          end
        end
      end
    end

  end
  
  describe '#add' do
    it 'should accept a Pitch object, and convert it to a pitch class' do
      pcs = PitchClassSet.new
      pcs.add Pitch.new(:semitone => 11)
      pcs.include?(11).should be_true
    end

    it 'should accept a Fixnum object' do
      pcs = PitchClassSet.new
      pcs.add 7
      pcs.include?(7).should be_true
    end
  end
  
  describe '#pitch_class_at' do
    it 'should return the pitch class at the given index' do
      cases = {
        PitchClassSet.new([0,2,4,5]) => { 0 => 0, 1 => 2, 2 => 4, -1 => 5, -2 => 4, -3 => 2 },
        PitchClassSet.new([1,2,5,11]) => { 0 => 1, 2 => 5, 5 => 2, -1 => 11, -2 => 5 },
        PitchClassSet.new([4,8]) => { 0 => 4, 1 => 8, -1 => 8, -2 => 4, 2 => 4 },
        PitchClassSet.new([6]) => { 0 => 6, 1 => 6, 5 => 6, -5 => 6 },
      }
      cases.each do |pcs, io_pairs|
        io_pairs.each do |input, output|
          pcs.pitch_class_at(input).should eq(output)
        end
      end
    end
  end
  
  describe '#prev_pitch_class' do
    it 'should return the pitch class before the given pitch class' do
      cases = {
        [[0,2,4,5], 2] => 0,
        [[1,2,5,11], 5] => 2,
        [[4,8], 4] => 8,
        [[6], 6] => 6,
      }
      cases.each do |inputs, output|
        PitchClassSet.new(inputs[0]).prev_pitch_class(inputs[1]).should eq(output)
      end
    end
  end
  
  describe '#next_pitch_class' do
    it 'should return the pitch class after the given pitch class' do
      cases = {
        [[0,2,4,5], 2] => 4,
        [[1,2,5,11], 5] => 11,
        [[4,8], 4] => 8,
        [[6], 6] => 6,
      }
      cases.each do |inputs, output|
        PitchClassSet.new(inputs[0]).next_pitch_class(inputs[1]).should eq(output)
      end
    end
  end

  describe '#to_interval_vector' do
    before :all do
      @cases = {
        PitchClassSet.new([0,2,4,5]) => IntervalVector.new([2,2,1,7]),
        PitchClassSet.new([1,5,6,8]) => IntervalVector.new([4,1,2,5]),
        PitchClassSet.new([3,8]) => IntervalVector.new([5,7]),
        PitchClassSet.new([5]) => IntervalVector.new([12]),
      }
    end

    it 'should produce a vector that reflects differences between pitch classes' do
      @cases.each do |pitch_class_set, interval_vector|
        pitch_class_set.to_interval_vector.intervals.should eq(interval_vector.intervals)
      end
    end
    
    it 'should produce a vector whose intervals sum to 12' do
      @cases.each do |pitch_class_set, interval_vector|
        SPCore::Statistics.sum(pitch_class_set.to_interval_vector.intervals).should eq(12)
      end
    end

    it 'should produce a vector whose interval count equals the pcs count' do
      @cases.each do |pitch_class_set, interval_vector|
        pitch_class_set.to_interval_vector.intervals.count.should eq(pitch_class_set.count)
      end
    end
  end
end
