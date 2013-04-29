require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::InstrumentPlugin do
  before :each do
    @plugin = InstrumentPlugin.new :name => "simple_plugin", :version => "0.0.1", :maker_proc => ->(sample_rate){ sample_rate }
  end

  context '.new' do
    it 'should assign name given during construction' do
      @plugin.name.should eq("simple_plugin")
    end
    
    it 'should assign version given during construction' do
      @plugin.version.should eq("0.0.1")
    end
    
    it 'should assign maker_proc given during construction' do
      @plugin.make_instrument(400).should eq(400)
    end
  end  
end
