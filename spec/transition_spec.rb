require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Transition do
  describe Transition::Immediate do
    describe '.new' do
      it "should assign duration of 0" do
        t = Transition::Immediate.new()
        t.duration.should eq(0)
      end
    end
  end
  
  describe Transition::Linear do
    describe '.new' do
      it "should assign duration given" do
        t = Transition::Linear.new(1.5)
        t.duration.should eq(1.5)
      end
    end
  end
  
  describe Transition::Immediate do
    describe '.new' do
      it "should assign duration and abruptness given" do
        t = Transition::Sigmoid.new(1.2, 0.4)
        t.duration.should eq(1.2)
        t.abruptness.should eq(0.4)
      end
    end
  end
end