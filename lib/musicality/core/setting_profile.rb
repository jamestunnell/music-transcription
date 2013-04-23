module Musicality

# Represent a setting that can change over time.
# 
# @author James Tunnell
#
class SettingProfile
  include Hashmake::HashMakeable
  
  attr_accessor :start_value, :value_changes
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :start_value => arg_spec(:reqd => true),
    :value_changes => arg_spec_array(:reqd => false, :type => ValueChange)
  }

  # A new instance of SettingProfile.
  #
  # @param [Hash] args Hashed args. Required key is :start_value. Optional key is :value_changes.
  def initialize args
    hash_make SettingProfile::ARG_SPECS, args
  end
  
  # Compare to another SettingProfile object.
  def == other
    (self.class == other.class) && 
    (self.start_value == other.start_value) &&
    (self.value_changes == other.value_changes)
  end
  
  # Produce an identical SettingProfile object.
  def clone
    SettingProfile.new(:start_value => @start_value, :value_changes => @value_changes.clone)
  end
  
  # Returns true if start value and value changes all are between given A and B.
  def values_between? a, b
    is_ok = self.start_value.between?(a,b)
    
    if is_ok
      self.value_changes.each do |event|
        event.value.between?(a,b)
      end
    end
    return is_ok
  end

  # Returns true if start value and value changes all are greater than zero.
  def values_positive?
    is_ok = self.start_value > 0.0
    
    if is_ok
      self.value_changes.each do |event|
        event.value > 0.0
      end
    end
    return is_ok
  end

end

end
