require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'spcore'

describe RhythmicPattern do
  context '.new' do
    it 'should raise ArgumentError if no parts are given' do
      lambda { RhythmicPattern.new([]) }.should raise_error(ArgumentError)
    end
    
    it 'should assign given parts' do
      parts = [1,2,3]
      RhythmicPattern.new(parts).parts.should eq parts
    end
  end
  
  context '#to_durations' do
    before :all do
      @parts_cases = [
        [1,1],
        [1],
        [2,1],
        [2,1,1]
      ]
      
      @total_duration_cases = [
        1.0, 0.5, 0.2, 4.5
      ]
    end
    
    it 'should raise ArgumentError if total duration given is negative' do
      lambda { RhythmicPattern.new([1,2]).to_durations(-1.0) }.should raise_error(ArgumentError)
    end

    it 'should raise ArgumentError if total duration given is zero' do
      lambda { RhythmicPattern.new([1,2]).to_durations(0) }.should raise_error(ArgumentError)
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
