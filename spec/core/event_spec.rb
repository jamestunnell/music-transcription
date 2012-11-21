require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Event do
  
  it "should assign offset, value, and duration given during construction" do
    event = Musicality::Event.new 0, 0, 0
    event.offset.should eq(0)
    event.value.should eq(0)
    event.duration.should eq(0)
    
    event = Musicality::Event.new 1, 2, 3
    event.offset.should eq(1)
    event.value.should eq(2)
    event.duration.should eq(3)
  end

  context "Event.hash_events_by_offset" do
    it "should take an array of events and convert them to a Hash by offset" do
      events = [
        Musicality::Event.new(0, 4, 2),
        Musicality::Event.new(1, 5, 1),
        Musicality::Event.new(2, 6, 0)
      ]
      
      hashed = Event.hash_events_by_offset events
      events.each do |event|
        hashed[event.offset].should be
        hashed[event.offset].offset.should eq(event.offset)
        hashed[event.offset].value.should eq(event.value)
        hashed[event.offset].duration.should eq(event.duration)
      end
    end
  end

  context "Event.hash_events_by_duration" do
    it "should take an array of events and convert them to a Hash by duration" do
      events = [
        Musicality::Event.new(0, 4, 2),
        Musicality::Event.new(1, 5, 1),
        Musicality::Event.new(2, 6, 0)
      ]
      
      hashed = Event.hash_events_by_duration events
      events.each do |event|
        hashed[event.duration].should be
        hashed[event.duration].offset.should eq(event.offset)
        hashed[event.duration].value.should eq(event.value)
        hashed[event.duration].duration.should eq(event.duration)
      end
    end
  end

end
