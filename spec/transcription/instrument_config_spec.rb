require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe InstrumentConfig do

  it "should assign the given name" do
    cfg = InstrumentConfig.new :plugin_name => "MyPluginName"
    cfg.plugin_name.should eq("MyPluginName")
  end
  
  it "should assign the given initial settings" do
    settings = {
      :volume => 0.5,
      :gain => 0.75,
    }
    cfg = InstrumentConfig.new :plugin_name => "MyPluginName", :initial_settings => settings
    cfg.initial_settings.should eq(settings)
  end

  it "should allow a String to be given as initial settings" do
    settings = "preset A"
    cfg = InstrumentConfig.new :plugin_name => "MyPluginName", :initial_settings => settings
    cfg.initial_settings.should eq(settings)
  end
  
  it "should allow an Array to be given as initial settings" do
    settings = ["preset A","preset B"]
    cfg = InstrumentConfig.new :plugin_name => "MyPluginName", :initial_settings => settings
    cfg.initial_settings.should eq(settings)
  end
  
  it "should assign each of the given setting changes" do
    setting_changes = {
      1.0 => {
        :volume => ValueChange.new(:value => 0.5),
        :gain => ValueChange.new(:value => 0.75),
      },
      4.0 => {
        :volume => ValueChange.new(:value => 0.1),
        :gain => ValueChange.new(:value => 0.1),
      }
    }
    
    cfg = InstrumentConfig.new :plugin_name => "MyPluginName", :setting_changes => setting_changes
    cfg.setting_changes.should eq(setting_changes)
  end

end
