module Musicality

class PluginConfig
  include HashMake

  attr_accessor :name, :settings

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:name, String, ->{""}) ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg(:settings, Hash, ->{ {} }) ]  
  
  def initialize args={}
    process_args args
  end
end

end
