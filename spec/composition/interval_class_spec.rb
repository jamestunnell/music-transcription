require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::IntervalClass do
  describe '.from_two_pitch_classes' do
    it 'should return to smallest pitch class distance' do
      { [5,9] => 4,
        [8,1] => 5,
        [9,3] => 6,
        [4,0] => 4,
        [4,11] => 5,
        [6,0] => 6
      }.each do |pitch_classes, expected_interval_class|
        IntervalClass.from_two_pitch_classes(*pitch_classes).should eq expected_interval_class
      end
    end
  end
end
