require 'pry'
module Musicality

# Contains plugin name string, and any plugin settings (via an
# array of SettingProfile). Is hash-makeable.
#
# @author James Tunnell
class PluginConfig
  include Hashmake::HashMakeable

  attr_accessor :plugin_name, :settings

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :plugin_name => arg_spec(:reqd => true, :type => String),
    :settings => arg_spec_hash(:reqd => false, :type => SettingProfile)
  }
  
  # A new instance of PluginConfig.
  # @param [Hash] args Hashed arguments. Required key is :plugin_name (String).
  #                    Optional key is :settings (Array of SettingProfile).
  def initialize args={}
    hash_make PluginConfig::ARG_SPECS, args
  end
end

end
