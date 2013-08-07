require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Transition do
  
  context '.new' do
    it "should assign duration and type given during construction" do
      t = Transition.new(:duration => 1.5, :type => Transition::LINEAR)
      t.duration.should eq(1.5)
      t.type.should eq(Transition::LINEAR)
    end
  end

end
