require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Event do
  
  before :each do
  end

  it "should assign offset and duration given during construction" do
    event = Musicality::Event.new 0.to_r, 0.to_r
    event.offset.should eq(0)
    event.duration.should eq(0)
    
    event = Musicality::Event.new 1.to_r, 1.to_r
    event.offset.should eq(1)
    event.duration.should eq(1)
  end

  context "Event.hash_events_by_offset" do
    it "should take an array of events and convert them to a Hash by offset" do
      events = [
        Musicality::Event.new(0.to_r, 2.to_r),
        Musicality::Event.new(1.to_r, 1.to_r),
        Musicality::Event.new(2.to_r, 0.to_r)
      ]
      
      hashed = Event.hash_events_by_offset events
      events.each do |event|
        hashed[event.offset].should be
        hashed[event.offset].offset.should eq(event.offset)
        hashed[event.offset].duration.should eq(event.duration)
      end
    end
  end

  context "Event.hash_events_by_duration" do
    it "should take an array of events and convert them to a Hash by duration" do
      events = [
        Musicality::Event.new(0.to_r, 2.to_r),
        Musicality::Event.new(1.to_r, 1.to_r),
        Musicality::Event.new(2.to_r, 0.to_r)
      ]
      
      hashed = Event.hash_events_by_duration events
      events.each do |event|
        hashed[event.duration].should be
        hashed[event.duration].offset.should eq(event.offset)
        hashed[event.duration].duration.should eq(event.duration)
      end
    end
  end

end
