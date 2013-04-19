require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PluginConfig do

  it "should assign the given name" do
    cfg = PluginConfig.new :plugin_name => "MyPluginName"
    cfg.plugin_name.should eq("MyPluginName")
  end
  
  it "should assign the given settings" do
    settings = {
      :volume => SettingProfile.new(:start_value => 0.5),
      :gain => SettingProfile.new(:start_value => 0.75)
    }
    cfg = PluginConfig.new :plugin_name => "MyPluginName", :settings => settings
    cfg.settings.should eq(settings.clone)
  end

  it "should be hash-makeable" do
    settings = {
      :volume => 0.5,
      :gain => 0.75
    }
    hash = { :plugin_name => "MyPluginName", :settings => settings }
    cfg = PluginConfig.new hash
    
    cfg.plugin_name.should eq("MyPluginName")
    cfg.settings[:volume].should eq(0.5)
    cfg.settings[:gain].should eq(0.75)
  end
end
