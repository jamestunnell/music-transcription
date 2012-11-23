module Musicality

# Represent a setting that can change over time.
# 
# @author James Tunnell
#
class SettingProfile
  include HashMake
  
  attr_accessor :start_value, :value_change_events
  
  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:start_value) ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_array(:value_change_events, Event) ]

  # A new instance of SettingProfile.
  #
  # @param [Hash] args Hashed args. Required key is :start_value. Optional key is :value_change_events.
  def initialize args
    process_args args
  end
  
  # Compare to another SettingProfile object.
  def == other
    (self.class == other.class) && 
    (self.start_value == other.start_value) &&
    (self.value_change_events == other.value_change_events)
  end
  
  # Returns true if start value and value changes all are between given A and B.
  def values_between? a, b
    is_ok = self.start_value.between?(a,b)
    
    if is_ok
      self.value_change_events.each do |event|
        event.value.between?(a,b)
      end
    end
    return is_ok
  end

  # Returns true if start value and value changes all are greater than zero.
  def values_positive?
    is_ok = self.start_value > 0.0
    
    if is_ok
      self.value_change_events.each do |event|
        event.value > 0.0
      end
    end
    return is_ok
  end

end

end
