require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::PluginView do
  it "should show no plugins when extension points are given" do
    view = PluginView.new
    view.plugins.should be_empty
  end

  it "should show :flat_plugin when :envelope extension point is given" do
    view = PluginView.new [ :envelope ]
    view.plugins.should have_key :flat_envelope
  end

  it "should show no :oscillator_voice when :voice extension point is given" do
    view = PluginView.new [ :voice ]
    view.plugins.should have_key :oscillator_voice
  end

  it "should show no :oscillator_voice and :flat_envelope when :envelope and :voice extension points are given" do
    view = PluginView.new [ :envelope, :voice ]
    view.plugins.should have_key :flat_envelope
    view.plugins.should have_key :oscillator_voice
  end
end
