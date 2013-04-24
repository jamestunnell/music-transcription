require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::ValueChange do
  
  context '.new' do
    it "should assign offset, value, and duration given during construction" do
      event = Musicality::ValueChange.new(:value => 0)
      event.value.should eq(0)
      event.transition.type.should eq(Transition::IMMEDIATE)
      event.transition.duration.should eq(0)
      
      event = Musicality::ValueChange.new(:value => 2, :transition => Musicality::linear(3))
      event.value.should eq(2)
      event.transition.type.should eq(Transition::LINEAR)
      event.transition.duration.should eq(3)
    end
  end

end
