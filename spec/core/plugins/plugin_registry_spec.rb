require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::PluginRegistry do
  describe PluginRegistry.new do
    its(:plugins) { should be_empty }
  end
  
  describe "#register" do
    before :all do
      @registry = PluginRegistry.new      
    end
    
    it "should register a plugin" do
      @registry.register :plugin_a do
        self.author = "James Tunnell"
        self.version = "1.0.2"
      end
      
      @registry.plugins.should have_key :plugin_a
    end

    it "should clear plugins" do
      @registry.clear_plugins
      @registry.plugins.should be_empty
    end
  end

end