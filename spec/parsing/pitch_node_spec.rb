require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Parsing::PitchNode do
  parser = Parsing::PitchParser.new
  
  {
    'C4' => C4,
    'Db2' => Db2,
    'C#2' => Db2,
    'Db2' => Db2,
    'F7' => F7,
    'B1' => B1,
  }.each do |str,tgt|
    res = parser.parse(str)
    context str do
      it 'should parse as PitchNode' do
        res.should be_a Parsing::PitchNode
      end
      
      describe '#to_pitch' do
        p = res.to_pitch
        it 'should produce a Pitch object' do
          p.should be_a Pitch
        end
        
        it 'should produce pitch matching input str' do
          p.should eq tgt
        end
      end
    end
  end  
end
