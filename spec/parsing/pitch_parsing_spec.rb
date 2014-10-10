require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Parsing::PitchParser do
  before :all do
    @parser = Parsing::PitchParser.new
  end
  
  it 'should parse "C4"' do
    @parser.parse("C4").should_not be nil
  end
  
  it 'should parse "C#9"' do
    @parser.parse("C#9").should_not be nil
  end
  
  it 'should parse "Ab0"' do
    @parser.parse("Ab0").should_not be nil
  end
  
  it 'should parse "G#2"' do
    @parser.parse("G#2").should_not be nil
  end
end
