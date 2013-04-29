require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::InstrumentPluginRegistry do
  describe InstrumentPluginRegistry.new do
    its(:plugins) { should be_empty }
  end
  
  describe "#register" do
    before :all do
      @registry = InstrumentPluginRegistry.new      
    end
    
    it "should register a plugin" do
      @registry.register InstrumentPlugin.new(
        :name => "plugin_a",
        :author => "James Tunnell",
        :version => "1.0.2",
        :maker_proc => ->(sample_rate){}
      )
      
      @registry.plugins.should have_key "plugin_a"
    end

    it "should clear plugins" do
      @registry.clear_plugins
      @registry.plugins.should be_empty
    end
  end

end