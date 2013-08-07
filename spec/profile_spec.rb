require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Profile do
  
  context '.new' do
    it "should assign start value given during construction" do
      p = Profile.new(:start_value => 0.2)
      p.start_value.should eq(0.2)
    end
    
    it "should assign settings given during construction" do
      p = Profile.new(
        :start_value => 0.2,
        :value_changes => {
          1.0 => ValueChange.new(:value => 0.5),
          1.5 => ValueChange.new(:value => 1.0)
        }
      )
      p.value_changes[1.0].value.should eq(0.5)
      p.value_changes[1.5].value.should eq(1.0)
    end
  end

end
