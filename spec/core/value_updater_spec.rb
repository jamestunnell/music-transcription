require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::ValueComputer do
  
  before :each do
    value_change = Event.new 0.5, 0.2, 0.5
    value_computer = ValueComputer.new 1.0, [value_change]
    @value_updater = ValueUpdater.new value_computer, 0.0
  end

  it "should be at start/default value if nothing has been called yet" do
    @value_updater.value.should eq(1.0)
  end
  
  it "should call #value_changed on registered observers when value has changed" do
    updates = []
    
    @value_updater.when :value_changed do |val|
      updates << val
    end
    
    @value_updater.update_value 0.1
    updates.should be_empty
    
    @value_updater.update_value 0.51
    updates.count.should be 1
    
    @value_updater.update_value 0.52
    updates.count.should be 2
    updates.last.should_not eq(updates.first)
    
    @value_updater.update_value 0.52
    updates.count.should be 2
    
    @value_updater.update_value 0.75
    updates.count.should be 3
    updates.last.should be_within(0.01).of(0.6)
    
    @value_updater.update_value 1.0
    updates.count.should be 4
    updates.last.should be_within(0.01).of(0.2)
    
    @value_updater.update_value 1.1
    updates.count.should be 4
  end
end