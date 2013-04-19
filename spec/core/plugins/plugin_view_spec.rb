require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::PluginView do
  it "should show no plugins when extension points are given" do
    view = PluginView.new
    view.plugins.should be_empty
  end

  it "should show :flat_plugin when :envelope extension point is given" do
    view = PluginView.new [ :envelope ]
    view.plugins.should have_key :flat_envelope
    view.plugins.should_not have_key :synth_instr_6_1
  end

  it "should show :synth_instr_6_1 when :instrument extension point is given" do
    view = PluginView.new [ :instrument ]
    view.plugins.should have_key :synth_instr_1
  end

  it "should show both :synth_instr_6_1 and :flat_envelope when :envelope and :instrument extension points are given" do
    view = PluginView.new [ :envelope, :instrument ]
    view.plugins.should have_key :flat_envelope
    view.plugins.should have_key :synth_instr_1
  end
end
