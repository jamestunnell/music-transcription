module Musicality
  
# A plugin, including metadata (name, author, version, description) and a
# Proc for creating new instrument instances.
#
# Taken and modified from the PlugMan library.
class InstrumentPlugin
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :name => arg_spec(:reqd => true, :type => String),
    :version => arg_spec(:reqd => true, :type => String),
    :maker_proc => arg_spec(:reqd => true, :type => Proc, :validator => ->(a){ a.arity == 1 }), # will be passed sample rate
    :author => arg_spec(:reqd => false, :type => String, :default => ->(){ "" }),
    :description => arg_spec(:reqd => false, :type => String, :default => ->(){ "" }),
  }
  
  attr_reader :name, :version, :author, :description
  def initialize args
    hash_make InstrumentPlugin::ARG_SPECS, args
  end
  
  def make_instrument sample_rate, initial_settings = {}
    instrument = @maker_proc.call(sample_rate)
    
    initial_settings.each do |name, val|
      if instrument.params.include? name
        instrument.params[name].set_value val
      end
    end
  
    return instrument
  end
    
  def self.make_instrument sample_rate, config
    unless INSTRUMENTS.plugins.has_key?(config.plugin_name)
      raise ArgumentError, "instrument plugin #{config.plugin_name} is not registered"
    end
    
    plugin = INSTRUMENTS.plugins[config.plugin_name]
    return plugin.make_instrument(sample_rate, config.initial_settings)
  end  
end
  
end
