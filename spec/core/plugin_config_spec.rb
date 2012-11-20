require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PluginConfig do

  it "should assign the given name" do
    cfg = PluginConfig.new :name => "MyPluginName"
    cfg.name.should eq("MyPluginName")
  end
  
  it "should assign the given settings" do
    settings = { 1 => "a", 2 => "b" }
    cfg = PluginConfig.new :name => "MyPluginName", :settings => settings
    cfg.settings.should eq(settings.clone)
  end

  it "should be hash-makeable" do
    HashMakeUtil.is_hash_makeable?(PluginConfig).should be_true
    
    PluginConfig.new( :name => "MyPluginName" ).save_to_hash.should have_key(:name)
    
    settings = { 1 => "a", 2 => "b" }
    hash = { :name => "MyPluginName", :settings => settings }
    cfg = PluginConfig.make_from_hash hash
    hash2 = cfg.save_to_hash
    hash.should eq(hash2)
    
    cfg2 = PluginConfig.make_from_hash hash2
    
    cfg.name.should eq(cfg2.name)
    cfg.settings.should eq(cfg2.settings)
  end
end
