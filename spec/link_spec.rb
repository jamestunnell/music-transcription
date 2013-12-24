require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Link do
  context '.new' do
    it 'should assign the given pitch to :target_pitch' do
      Link.new(C2).target_pitch.should eq(C2)
    end
  end
    
  describe '==' do
    it 'should return true if two links have the same target pitch' do
      Link.new(C2).should eq(Link.new(C2))
    end
    
    it 'should return false if two links do not have the same target pitch' do
      Link.new(C2).should_not eq(Link.new(F5))
    end
  end
  
  describe 'clone' do
    it 'should return a link with the same target pitch' do
      l = Link.new(C4)
      l.clone.should eq(l)
    end
  end
end
