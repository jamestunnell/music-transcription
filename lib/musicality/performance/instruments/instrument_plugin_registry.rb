require 'logger'
require 'publisher'
require 'find'

module Musicality

class InstrumentPluginRegistry
  extend Publisher
  can_fire :plugins_loaded, :plugins_cleared

  attr_reader :plugins
  
  def initialize
    @plugins = {}
    
    @logger = Logger.new(STDOUT)
    #@logger.level = Logger::DEBUG
    @logger.level = Logger::ERROR
  end
  
  # Load all the plugins in the given plugin dir.
  def load_plugins(plugin_dir)
    prev_plugins = @plugins.clone
    
    Find.find(plugin_dir) do |path|
      if path =~ /\.rb$/
        @current_load_path = path # nasty, nasty, nasty.  Need a better way to pass a plugin's load path to it.
        load path
      end
    end
    
    new_plugins = @plugins.reject {|key, plugin| prev_plugins.has_key? key}
    fire :plugins_loaded, new_plugins
  end
  
  # Remove all registered plugins.
  def clear_plugins
    @plugins.clear
    fire :plugins_cleared
  end

  #
  # Registers a plugin. See InstrumentPlugin class for more information.
  # 
  # If a plugin is registered more than once, the instance with the greatest version
  # number will be used (any older version will be discarded.)
  #
  def register plugin
    # check for existing plugin with this name
    exist = @plugins[plugin.name]
    if exist && exist.version > plugin.version
      @logger.warn { "Plugin #{plugin.name.inspect} already exists with newer version of #{exist.version} (attempted to register version #{plugin.version}.)" }
    else
      if exist && plugin.version >= exist.version
        @logger.warn { "Plugin #{plugin.name.inspect} already exists with older version of #{exist.version}, replacing with version #{plugin.version}." }
      end
      @plugins[plugin.name] = plugin
    end

    @logger.debug { "Registered plugin #{plugin.name.inspect}" }
  end
end

INSTRUMENTS = InstrumentPluginRegistry.new

end
