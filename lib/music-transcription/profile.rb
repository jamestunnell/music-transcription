module Music
module Transcription

# Represent a setting that can change over time.
# 
# @author James Tunnell
#
class Profile
  attr_accessor :start_value, :value_changes

  def initialize start_value, value_changes = {}
    @start_value = start_value
    @value_changes = value_changes
  end
  
  # Compare to another Profile object.
  def == other
    (self.start_value == other.start_value) &&
    (self.value_changes == other.value_changes)
  end
  
  # Produce an identical Profile object.
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  def last_value
    if @value_changes.empty?
      return @start_value
    else
      return @value_changes[@value_changes.keys.max].value
    end
  end
  
  def changes_before? offset
    @value_changes.count {|k,v| k < offset } > 0
  end

  def changes_after? offset
    @value_changes.count {|k,v| k > offset } > 0
  end

  # move changes forward or back by some offset
  def shift amt
    self.clone.shift! amt
  end
  
  # move changes forward or back by some offset
  def shift! amt
    @value_changes = Hash[@value_changes.map {|k,v| [k+amt,v]}]
    return self
  end
  
  def stretch ratio
    self.clone.stretch! ratio
  end

  def stretch! ratio
    @value_changes = Hash[ @value_changes.map {|k,v| [k*ratio,v] }]
    return self
  end
  
  def append profile, offset
    self.clone.append! profile
  end

  def append! profile, start_offset
    if @value_changes.any? && start_offset < @value_changes.keys.max
      raise ArgumentError, "appending profile overlaps"
    end
    
    lv = self.last_value
    unless lv == profile.start_value
      @value_changes[start_offset] = Change::Immediate.new(profile.start_value)
      lv = profile.start_value
    end
    
    shifted = profile.shift(start_offset)
    shifted.value_changes.sort.each do |offset,value_change|
      unless value_change.value == lv
	@value_changes[offset] = value_change
	lv = value_change.value
      end
    end
    return self
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
    new_profile = Profile.new start_value
    
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
      new_profile.value_changes[offset] = value_change(value)
      
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

end
end
