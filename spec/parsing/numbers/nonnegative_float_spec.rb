require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Parsing::NonnegativeFloatParser do
  parser = Parsing::NonnegativeFloatParser .new

  ["1.0","0.50","05.003e-10","1.555e+2","3.443214"].each do |str|
    it "should parse '#{str}'" do
      parser.parse(str).should_not be nil
    end
  end
end
