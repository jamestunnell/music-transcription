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
    HashMakeUtil.is_hash_makeable?(PluginConfig).should be_true
    
    PluginConfig.new( :plugin_name => "MyPluginName" ).save_to_hash.should have_key(:plugin_name)
    
    settings = {
      :volume => { :start_value => 0.5 },
      :gain => { :start_value => 0.75 }
    }
    hash = { :plugin_name => "MyPluginName", :settings => settings }
    cfg = PluginConfig.make_from_hash hash
    hash2 = cfg.save_to_hash
    hash.should eq(hash2)
    
    cfg2 = PluginConfig.make_from_hash hash2
    
    cfg.plugin_name.should eq(cfg2.plugin_name)
    cfg.settings[:volume].start_value.should eq(cfg2.settings[:volume].start_value)
    cfg.settings[:gain].start_value.should eq(cfg2.settings[:gain].start_value)
  end
end
