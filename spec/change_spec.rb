require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Change::Immediate do
  context '.new' do
    it 'should set value to given' do
      Change::Immediate.new(5).value.should eq 5
    end
    
    it 'should set duration to 0' do
      Change::Immediate.new(5).duration.should eq 0
    end
  end
    
  describe '==' do
    it 'should return true if two immediate changes have the same value' do
      Change::Immediate.new(5).should eq(Change::Immediate.new(5))
    end
    
    it 'should return false if two immediate changes do not have the same value' do
      Change::Immediate.new(5).should_not eq(Change::Immediate.new(4))
    end
  end  
end

describe Change::Gradual do
  context '.new' do
    it 'should set value to given value' do
      Change::Gradual.new(5,2).value.should eq 5
    end
    
    it 'should set duration to given duration' do
      Change::Gradual.new(5,2).duration.should eq 2
    end
  end
    
  describe '==' do
    it 'should return true if two gradual changes have the same value and duration' do
      Change::Gradual.new(5,2).should eq(Change::Gradual.new(5,2))
    end
    
    it 'should return false if two gradual changes do not have the same value' do
      Change::Gradual.new(5,2).should_not eq(Change::Gradual.new(4,2))
    end
    
    it 'should return false if two gradual changes do not have the same duration' do
      Change::Gradual.new(5,2).should_not eq(Change::Gradual.new(5,1))
    end
  end  
end