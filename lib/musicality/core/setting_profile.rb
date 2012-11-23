module Musicality

class SettingProfile
  include HashMake
  
  attr_accessor :start_value, :value_change_events
  
  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:start_value) ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_array(:value_change_events, Event) ]

  def initialize args
    process_args args
  end
end

end
