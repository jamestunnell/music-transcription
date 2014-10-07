require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Link::Glissando do
  describe '#initialize' do
    it 'should assign the given pitch to :target_pitch' do
      Link::Glissando.new(C2).target_pitch.should eq(C2)
    end
  end
  
  describe '#==' do
    it 'should return true if two links have the same target pitch' do
      Link::Glissando.new(C2).should eq(Link::Glissando.new(C2))
    end
    
    it 'should return false if two links do not have the same target pitch' do
      Link::Glissando.new(C2).should_not eq(Link::Glissando.new(F5))
    end
    
    it 'should return false if the link type is different' do
      Link::Glissando.new(C2).should_not eq(Link::Portamento.new(D2))
    end
  end
  
  describe '#clone' do
    it 'should return a link equal to original' do
      l = Link::Glissando.new(C4)
      l.clone.should eq l
    end
  end
  
  describe '#to_yaml' do
    it 'should produce YAML that can be loaded' do
      l = Link::Glissando.new(C5)
      YAML.load(l.to_yaml).should eq l
    end
  end
end
  
describe Link::Portamento do
  describe '#initialize' do
    it 'should assign the given pitch to :target_pitch' do
      Link::Portamento.new(C2).target_pitch.should eq(C2)
    end
  end
  
  describe '#==' do
    it 'should return true if two links have the same target pitch' do
      Link::Portamento.new(C2).should eq(Link::Portamento.new(C2))
    end
    
    it 'should return false if two links do not have the same target pitch' do
      Link::Portamento.new(C2).should_not eq(Link::Portamento.new(F5))
    end
    
    it 'should return false if the link type is different' do
      Link::Portamento.new(C2).should_not eq(Link::Glissando.new(D2))
    end
  end
  
  describe '#clone' do
    it 'should return a link equal to original' do
      l = Link::Portamento.new(C4)
      l.clone.should eq l
    end
  end
  
  describe '#to_yaml' do
    it 'should produce YAML that can be loaded' do
      l = Link::Portamento.new(C5)
      YAML.load(l.to_yaml).should eq l
    end
  end
end

describe Link::Tie do
  describe '#==' do
    it 'should return true if another Tie object is given' do
      Link::Tie.new.should eq(Link::Tie.new)
    end
    
    it 'should return false if a non-Tie object is given' do
      Link::Tie.new.should_not eq(Link::Portamento.new(C2))
    end
  end
  
  describe '#clone' do
    it 'should return a link equal to original' do
      l = Link::Tie.new
      l.clone.should eq l
    end
  end
  
  describe '#to_yaml' do
    it 'should produce YAML that can be loaded' do
      l = Link::Tie.new
      YAML.load(l.to_yaml).should eq l
    end
  end
end
