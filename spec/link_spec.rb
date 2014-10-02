require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Link do
  context '#initialize' do
    it 'should assign the given pitch to :target_pitch' do
      Link.new(C2).target_pitch.should eq(C2)
    end
  end
    
  describe '#==' do
    it 'should return true if two links have the same target pitch' do
      Link.new(C2).should eq(Link.new(C2))
    end
    
    it 'should return false if two links do not have the same target pitch' do
      Link.new(C2).should_not eq(Link.new(F5))
    end
    
    it 'should return false if the link type is different' do
      Link::Slur.new(C2).should_not eq(Link::Legato.new(D2))
    end
  end
  
  describe '#clone' do
    it 'should return a link with the same target pitch' do
      l = Link.new(C4)
      l.clone.target_pitch.should eq(C4)
    end
    
    it 'should return a link with the same class' do
      l = Link::Slur.new(Eb2)
      l.clone.class.should eq(Link::Slur)
    end
  end
  
  describe '#to_yaml' do
    it 'should produce YAML that can be loaded' do
      l = Link::Slur.new(C5)
      YAML.load(l.to_yaml).should eq l
    end
  end
end
