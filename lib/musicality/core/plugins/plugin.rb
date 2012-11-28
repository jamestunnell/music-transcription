module Musicality
  
  class Plugin

    # 
    # Metadata for the plugin, this helps the plugin system wire up the plugins
    # 
    attr_accessor :name,              # plugin name, set automagically from PlugMan.define param.
                  :author,            # plugin author. 
                  :version,           # plugin version.  Only latest version of a plugin can be active.
                  :extends,           # extension points this plugin extends [:extpt1, :extpt2]
                  #:requires,         # the plugins that are required by this plugin (not needed for extensions though)
                  :extension_points,  # extension points defined by this plugin [:ext_a:, :ext_b]
                  :params,            # parameters to pass to the parent plugin { :param1 => "abc", :param2 => 123 }
                  :source_file        # the file that the plugin was loaded from, populated by PlugMan.

    # Should not be called directly, use PluginRegistry.register instead.
    def initialize
      # give a logger to each plugin
      @logger = Logger.new(STDOUT)
      #@logger.level = Logger::DEBUG
      @logger.level = Logger::ERROR

      @name = ""
      @author = ""
      @version = ""
      @extends = []
      #@requires = []
      @extension_points = []
      @params = {}
      @source_file = ""
    end

    #
    #The base dir name that the plugin was loaded from
    #
    def dirname
      File.dirname source_file
    end
  
  end

end
