module Musicality

# Represent a setting that can change over time.
# 
# @author James Tunnell
#
class Profile
  include Hashmake::HashMakeable
  
  attr_accessor :start_value, :value_changes
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :start_value => arg_spec(:reqd => true),
    :value_changes => arg_spec_hash(:reqd => false, :type => ValueChange)
  }

  # A new instance of Profile.
  #
  # @param [Hash] args Hashed args. Required key is :start_value. Optional key is :value_changes.
  def initialize args
    hash_make args, Profile::ARG_SPECS
  end
  
  # Compare to another Profile object.
  def == other
    (self.class == other.class) && 
    (self.start_value == other.start_value) &&
    (self.value_changes == other.value_changes)
  end
  
  # Produce an identical Profile object.
  def clone
    Profile.new(:start_value => @start_value, :value_changes => @value_changes.clone)
  end
  
  # Returns true if start value and value changes all are between given A and B.
  def values_between? a, b
    is_ok = self.start_value.between?(a,b)
    
    if is_ok
      self.value_changes.each do |offset, setting|
        setting.value.between?(a,b)
      end
    end
    return is_ok
  end

  # Returns true if start value and value changes all are greater than zero.
  def values_positive?
    is_ok = self.start_value > 0.0
    
    if is_ok
      self.value_changes.each do |offset, setting|
        setting.value > 0.0
      end
    end
    return is_ok
  end
  
  def clone_and_collate computer_class, program_segments
    new_profile = Profile.new :start_value => start_value
    
    segment_start_offset = 0.0
    comp = computer_class.new(self)
    
    program_segments.each do |seg|
      # figure which dynamics to keep/modify
      changes = Marshal.load(Marshal.dump(value_changes))
      changes.keep_if {|offset,change| seg.include?(offset) }
      changes.each do |offset, change|
	if(offset + change.transition.duration) > seg.last
	  change.transition.duration = seg.last - offset
	  change.value = comp.value_at seg.last
	end
      end
      
      # find & add segment start value first
      value = comp.value_at seg.first
      offset = segment_start_offset
      new_profile.value_changes[offset] = Musicality::value_change(value)
      
      # add changes to part, adjusting for segment start offset
      changes.each do |offset2, change|
	offset3 = (offset2 - seg.first) + segment_start_offset
	new_profile.value_changes[offset3] = change
      end
      
      segment_start_offset += (seg.last - seg.first)
    end
    
    return new_profile
  end
end

# Create a Profile object
def profile start_value, value_changes = {}
  return Profile.new(:start_value => start_value, :value_changes => value_changes)
end

end
