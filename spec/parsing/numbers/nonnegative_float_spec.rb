require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Parsing::NonnegativeFloatParser do
  parser = Parsing::NonnegativeFloatParser .new

  ["0.0","0e1","2e2","1.0","0.50","05.003e-10","1.555e+2","3.443214","0.001","0000.0030000"].each do |str|
    res = parser.parse(str)
    f = str.to_f
    
    it "should parse '#{str}'" do
      res.should_not be nil
    end

    it 'should return node that is convertible to float using #to_f method' do
      res.to_f.should eq(f)
    end
    
    it 'should return node that is convertible to float using #to_num method' do
      res.to_num.should eq(f)
    end
  end
  
  ["-1.0","-0e1"].each do |str|
    it "should not parse '#{str}'" do
      parser.should_not parse(str)
    end    
  end
end
