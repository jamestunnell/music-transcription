require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ValueChange do
  
  context '.new' do
    it "should assign offset, value, and duration given during construction" do
      event = ValueChange.new(0)
      event.value.should eq(0)
      event.transition.class.should eq(Transition::Immediate)
      event.transition.duration.should eq(0)
      
      event = ValueChange.new(2, Transition::Linear.new(3))
      event.value.should eq(2)
      event.transition.class.should eq(Transition::Linear)
      event.transition.duration.should eq(3)
    end
  end

end
