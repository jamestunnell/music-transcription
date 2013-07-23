require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'spcore'

describe RhythmicPattern do
  before :all do
    @cases = {}
    [
      [1,1],
      [1],
      [2,1],
      [2,1,1]
    ].each do |parts|
      @cases[parts] = RhythmicPattern.new parts
    end
  end

  context '.new' do
    it 'should raise error if no parts are given' do
      lambda { RhythmicPattern.new([]) }.should raise_error
    end
    
    it 'should assign given parts' do
      parts = [1,2,3]
      RhythmicPattern.new(parts).parts.should eq parts
    end
  end
  
  describe '#total' do
    it 'should sum the parts' do
      @cases.each do |parts, rhythmic_pattern|
        expected_sum = parts.inject(0){|sum,part| sum + part} 
        rhythmic_pattern.total.should eq(expected_sum)
      end
    end
  end

  describe '#to_fractions' do
    it 'should produce a fraction for each part' do
      @cases.each do |parts, rhythmic_pattern|
        rhythmic_pattern.to_fractions.count.should eq(parts.count)
      end
    end

    it 'should produce fractions that have each part in the numerator and total in denominator' do
      @cases.each do |parts, rhythmic_pattern|
        fractions = rhythmic_pattern.to_fractions
        fractions.each_index do |i|
          fraction = fractions[i].should eq(Rational(parts[i], rhythmic_pattern.total))
        end
      end
    end
  end

  describe '#to_durations' do
    before :all do
      @parts_cases = [
      ]
      
      @total_duration_cases = [
        1.0, 0.5, 0.2, 4.5
      ]
    end
    
    it 'should raise error if total duration given is negative' do
      lambda { RhythmicPattern.new([1,2]).to_durations(-1.0) }.should raise_error
    end

    it 'should raise error if total duration given is zero' do
      lambda { RhythmicPattern.new([1,2]).to_durations(0) }.should raise_error
    end
    
    it 'should create durations that add up to the total duration given' do
      @parts_cases.each do |parts|
        @total_duration_cases.each do |total_duration|
          durations = RhythmicPattern.new(parts).to_durations(total_duration)
          SPCore::Statistics.sum(durations).should eq total_duration
        end
      end
    end
  end
end
