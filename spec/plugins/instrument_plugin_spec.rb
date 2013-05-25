require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::InstrumentPlugin do
  context '.new' do
    before :all do
      @plugin = InstrumentPlugin.new :name => "simple_plugin", :version => "0.0.1", :maker_proc => ->(sample_rate){ sample_rate }
    end

    it 'should assign name given during construction' do
      @plugin.name.should eq("simple_plugin")
    end
    
    it 'should assign version given during construction' do
      @plugin.version.should eq("0.0.1")
    end
    
    it 'should assign maker_proc given during construction' do
      @plugin.make_instrument(400).should eq(400)
    end
  end
  
  describe '#make_instrument' do
    class ParamMock
      attr_reader :val
      def initialize val
        @val = val
      end
      def get_value
        @val
      end
      def set_value val
        @val = val
      end
    end
    
    class InstrMock
      attr_reader :sample_rate, :params
      def initialize sample_rate, params = {}
        @sample_rate = sample_rate
        @params = {}
        params.each do |name,val|
          @params[name] = ParamMock.new(val)
        end
      end
    end
    
    before :all do
      @defaults = {:a => 1, :b => 2, :c => 3, :d => 4}
      @plugin = InstrumentPlugin.new(
        :name => "presets_plugin",
        :version => "1.0.0",
        :maker_proc => ->(sample_rate){ return InstrMock.new(sample_rate, @defaults) },
        :presets => {
          "preset A" => {:a => 2},
          "preset B" => {:b => 3},
          "preset C" => {:c => 4},
          "preset D" => {:d => 5},
        }
      )
    end
    
    it 'should assign sample rate given' do
      @plugin.make_instrument(400).sample_rate.should eq(400)
    end
     
    it 'should not apply any settings when not given' do
      instr = @plugin.make_instrument(400)
      instr.params.each do |name,param|
        param.get_value.should eq(@defaults[name])
      end
    end

    it 'should apply settings when given as a hash' do
      instr = @plugin.make_instrument(400, :a => 2, :b => 3)
      instr.params[:a].get_value.should eq(2)
      instr.params[:b].get_value.should eq(3)
    end

    it 'should apply preset (if found) when a String is given instead of Hash for settings' do
      @plugin.presets.each do |preset_name, preset_hash|
        instr = @plugin.make_instrument(400, preset_name)
        
        preset_hash.each do |name, val|
          instr.params[name].get_value.should eq(val)
        end
      end
    end

    it 'should apply multiple presets (where found) when an Array of String objects is given instead of Hash for settings' do
      n_presets = @plugin.presets.count
      
      @plugin.presets.keys.combination(n_presets - 1) do |preset_combo|
        instr = @plugin.make_instrument(400, preset_combo)
        preset_combo.each do |preset_name|
          @plugin.presets[preset_name].each do |param_name, param_val|
            instr.params[param_name].get_value.should eq(param_val)
          end
        end
      end
    end

  end
end
