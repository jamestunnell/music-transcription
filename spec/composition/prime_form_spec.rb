require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PrimeForm do
  it 'should produce the expected ordering of pitch classes' do
    {
      [1,4,7,11] => [0,2,5,8],
      [2,7,1] => [0,1,6],
      [7,8,2,5] => [0,1,3,6],
      [0,1,4,5,7,9] => [0,1,3,5,8,9],
      [0,4,7] => [0,3,7],
      [0,3,7] => [0,3,7],
    }.each do |input_pitch_classes, expected_pitch_classes|
      prime_form = PrimeForm.new(input_pitch_classes)
      prime_form.pitch_classes.should eq(expected_pitch_classes)
    end
  end
end