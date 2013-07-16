require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NormalForm do
  it 'should order pitch classes so the largest interval is last' do
    [
      [0,3,5,8], [11,2,5], [7,11,4,6], [2,8,9],
    ].each do |input_pitch_classes|
      normal_form = NormalForm.new(input_pitch_classes)
      intervals = normal_form.interval_classes
      intervals.last.should eq(intervals.max)
    end
  end
end