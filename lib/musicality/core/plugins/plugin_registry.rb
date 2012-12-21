require 'logger'
require 'publisher'
require 'find'

module Musicality

  # Maintains a list of plugins that were created by calling '.register'.
  # Plugins should not be added any other way.
  # Taken and modified from the PlugMan library.
  class PluginRegistry
    extend Publisher
    can_fire :plugins_loaded, :plugins_cleared
  
    # a hash of all the registered plugins, key is a plugin name (as 
    # a symbol), value is the Plugin object.
    attr_reader :plugins
    
    def initialize
      @plugins = {}
  
      @logger = Logger.new(STDOUT)
      #@logger.level = Logger::DEBUG
      @logger.level = Logger::ERROR
      
      @current_load_path = ""
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
    # Registers a plugin.  See Plugin for more information about defining a plugin.
    # 
    # Do not simply create a plugin using Plugin.new as they won't be registered.
    # 
    # The plug_name must be unique amongst plugins and it will be 
    # converted to a symbol.  &block is the actual code that will 
    # make up the plugin (once again, see Plugin for more details.)  
    # 
    # Once a plugin is defined, it will be available using PlugMan.registered_plugins[:plug_name]
    # and any plugins that extend it can be discovered using PlugMan.extensions(:plug_name, ext_point)
    # 
    # If a plugin is declared more than once, the instance with the greatest version
    # number will be used (any older version will be discarded.)
    # 
    # When a plugin is initially defined, it is put into the :stopped state.
    #
    def register(plug_name, &block)
  
      # create plugin object and execute the metadata block
      p = Plugin.new
    
      # set some plugin metadata
      p.name = plug_name.to_sym
      p.source_file = @current_load_path
  
      p.instance_eval(&block)
  
      # check for existing plugin with this name
      exist = @plugins[plug_name.to_sym]
      if exist && exist.version > p.version
        @logger.warn { "Plugin #{plug_name.inspect} already exists with newer version of #{exist.version.to_s} (attempted to register version #{p.version.to_s}.)" }
      else
        if exist && p.version >= exist.version
          @logger.warn { "Plugin #{plug_name.inspect} already exists with older version of #{exist.version.to_s}, replacing with version #{p.version.to_s}." }      
        end
        @plugins[plug_name.to_sym] = p
      end
  
      p.extension_points [] unless p.extension_points
      #if !p.requires || p.requires.empty? && (!p.extends || p.extends.keys.empty?)
      #  p.requires [:root] unless p.name == ROOT_PLUGIN
      #end
  
      @logger.debug { "Created plugin #{plug_name.inspect}" + (p.extension_points.empty? ? "." : ", extension points: " + p.extension_points.join(", ")) }
    end
    
  end
end
