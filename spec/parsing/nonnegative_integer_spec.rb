require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NonnegativeIntegerParser do
  parser = NonnegativeIntegerParser.new

  ["1","50","05","502530","0"].each do |str|
    it "should parse '#{str}'" do
      parser.parse(str).should_not be nil
    end
  end
end
