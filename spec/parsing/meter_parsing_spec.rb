require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Parsing::MeterParser do
  parser = Parsing::MeterParser.new
  
  {
    '4/4' => FOUR_FOUR,
    '6/8' => SIX_EIGHT,
    '12/3' => Meter.new(12,"1/3".to_r),
    '9/8' => Meter.new(9,"1/8".to_r),
    '3/4' => THREE_FOUR
  }.each do |str,met|
    res = parser.parse(str)
    
    it "should parse #{str}" do
      res.should_not be nil
    end
    
    it 'should produce node that properly converts to meter' do
      res.to_meter.should eq met
    end
  end
end
