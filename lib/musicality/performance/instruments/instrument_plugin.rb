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
    
    def make_instrument sample_rate
      @maker_proc.call(sample_rate)
    end
    
    ## 
    ## Metadata for the plugin, this helps the plugin system wire up the plugins
    ## 
    #attr_accessor :name,              # plugin name, set automagically from PlugMan.define param.
    #              :author,            # plugin author. 
    #              :version,           # plugin version.  Only latest version of a plugin can be active.
    #              :description,       # about the plugin
    #              :source_file        # the file that the plugin was loaded from, populated by PluginRegistry.
    #
    ## Should not be called directly, use PluginRegistry.register instead.
    #def initialize
    #  # give a logger to each plugin
    #  @logger = Logger.new(STDOUT)
    #  #@logger.level = Logger::DEBUG
    #  @logger.level = Logger::ERROR
    #
    #  @name = ""
    #  @author = ""
    #  @version = ""
    #  @description = ""
    #  @source_file = ""
    #end
    #
    ##
    ##The base dir name that the plugin was loaded from
    ##
    #def dirname
    #  File.dirname source_file
    #end
  
  end
  
end
