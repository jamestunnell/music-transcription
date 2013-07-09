require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Interval do
  before :all do
    @pitch = C4
  end
  
  context '.new' do
    it "should assign :pitch parameter given during construction" do
      interval = Interval.new :pitch => @pitch
      interval.pitch.should eq(@pitch)
    end
    
    it "should assign :link parameter if given during construction" do
      link = Link.new(:relationship => Link::RELATIONSHIP_TIE, :target_pitch => @pitch)
      interval = Interval.new :pitch => @pitch, :link => link
      interval.link.should eq(link)
    end
  end
  
  context '#pitch=' do
    it "should assign pitch" do
      interval = Interval.new :pitch => @pitch
      interval.pitch = Gb4
      interval.pitch.should eq Gb4
    end
  end
  
  context '#link=' do
    it "should assign link" do
      link = Link.new(:relationship => Link::RELATIONSHIP_SLUR, :target_pitch => G2)
      interval = Interval.new :pitch => @pitch
      interval.link = link
      interval.link.should eq(link)
    end
  end

end