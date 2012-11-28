require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Plugin do
  describe Plugin.new do
    its(:name) { should be_empty }
    its(:author) { should be_empty }
    its(:version) { should be_empty }
    its(:extension_points) { should be_empty }
    its(:extends) { should be_empty }
    its(:params) { should be_empty }
    its(:source_file) { should be_empty }
  end
  
  context "empty plugin" do
    before :each do
      @plugin = Plugin.new
    end
    
    it "should assign name" do
      @plugin.name = "fuzzy"
      @plugin.name.should eq("fuzzy")
    end

    it "should assign author" do
      @plugin.author = "wuzzy"
      @plugin.author.should eq("wuzzy")
    end
    
    it "should assign version" do
      @plugin.version = "1.0.1"
      @plugin.version.should eq("1.0.1")
    end

    it "should assign extension points" do
      @plugin.extension_points = [:a, :b]
      @plugin.extension_points.should eq([:a, :b])
    end

    it "should assign extends" do
      @plugin.extends = [:c, :d]
      @plugin.extends.should eq([:c, :d])
    end

    it "should assign source file" do
      @plugin.source_file = "your_file"
      @plugin.source_file.should eq("your_file")
    end
  end
end
