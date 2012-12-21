module Musicality

# Contains plugin name string, and any plugin settings (via an
# array of SettingProfile). Is hash-makeable.
#
# @author James Tunnell
class PluginConfig
  include HashMake

  attr_accessor :plugin_name, :settings

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:plugin_name, String) ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_hash(:settings, SettingProfile) ]  
  
  # A new instance of PluginConfig.
  # @param [Hash] args Hashed arguments. Required key is :plugin_name (String).
  #                    Optional key is :settings (Array of SettingProfile).
  def initialize args={}
    process_args args
  end
end

end
