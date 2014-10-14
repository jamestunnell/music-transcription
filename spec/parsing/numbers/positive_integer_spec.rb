require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Parsing::PositiveIntegerParser do
  parser = Parsing::PositiveIntegerParser.new

  ["1","50","05","502530"].each do |str|
    it "should parse '#{str}'" do
      parser.parse(str).should_not be nil
    end
  end

  ["0"].each do |str|
    it "should not parse '#{str}'" do
      parser.parse(str).should be nil
    end
  end
end
