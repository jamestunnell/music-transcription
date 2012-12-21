require "logger"
require "set"

module Musicality
# Provide a method of listing the plugins in a given PluginRegistry.
# Only plugins which extend at least one of the given extension points
# will be shown.
class PluginView

  attr_accessor :extension_points
  
  # A new instance of PluginView.
  def initialize ext_points = [], registry = PLUGINS
    @logger = Logger.new(STDOUT)
    #@logger.level = Logger::DEBUG
    @logger.level = Logger::ERROR
    
    @extension_points = ext_points
    @registry = registry
  end

  # Returns all the plugins that use any of the current extension points.
  def plugins

    @logger.debug { "Finding plugins that have Get extensions for " << ext_point.to_s }
    # loop all the plugins in the system, weeding out the ones that are
    # not connected to the given extension point
    ret = {}
    
    @registry.plugins.each do |name, plugin|
      plugin.extends.each do |extend|
        if @extension_points.include? extend
          ret[name] = plugin
        end
      end
    end
    ret
  end
    
end
end
