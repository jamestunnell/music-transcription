require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "PLUGINS" do
  it "should have the :flat_envelope plugin" do
    PLUGINS.plugins.should have_key :flat_envelope
  end
    
  #context "after clearing and reloading" do
  #  before :each do
  #    PLUGINS.clear_plugins
  #    
  #    lib_path = File.expand_path(File.dirname(__FILE__) + '/../../../lib')
  #    PLUGINS.load_plugins lib_path
  #  end
  #        
  #  it "should load the :flat_envelope plugin" do
  #    PLUGINS.plugins.should have_key :flat_envelope
  #  end
  #end
end