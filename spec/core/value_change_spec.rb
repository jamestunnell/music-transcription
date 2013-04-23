require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::ValueChange do
  
  context '.new' do
    it "should assign offset, value, and duration given during construction" do
      event = Musicality::ValueChange.new(:offset => 0, :value => 0)
      event.offset.should eq(0)
      event.value.should eq(0)
      event.transition.type.should eq(Transition::IMMEDIATE)
      event.transition.duration.should eq(0)
      
      event = Musicality::ValueChange.new(:offset => 1, :value => 2, :transition => linear(3))
      event.offset.should eq(1)
      event.value.should eq(2)
      event.transition.type.should eq(Transition::LINEAR)
      event.transition.duration.should eq(3)
    end
  end
  
  context ".hash_events_by_offset" do
    it "should take an array of events and convert them to a Hash by offset" do
      events = [
        Musicality::ValueChange.new(:offset => 0, :value => 4, :transition => linear(2)),
        Musicality::ValueChange.new(:offset => 1, :value => 5, :transition => linear(1)),
        Musicality::ValueChange.new(:offset => 2, :value => 6, :transition => linear(0)),
      ]
      
      hashed = ValueChange.hash_events_by_offset events
      events.each do |event|
        hashed[event.offset].should be
        hashed[event.offset].offset.should eq(event.offset)
        hashed[event.offset].value.should eq(event.value)
        hashed[event.offset].transition.duration.should eq(event.transition.duration)
      end
    end
  end

end
