module Musicality

class PluginConfig
  include HashMake

  attr_accessor :plugin_name, :settings

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:plugin_name, String) ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_hash(:settings, SettingProfile) ]  
  
  def initialize args={}
    process_args args
  end
end

end
