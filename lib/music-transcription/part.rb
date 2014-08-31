require 'yaml'

module Music
module Transcription

# Abstraction of a musical part. Contains notes and loudness_profile settings.
#
# @author James Tunnell
#
# @!attribute [r] notes
#   @return [Array] The notes to be played.
#
# @!attribute [r] dynamic_profile
#   @return [Profile] Dynamic values profile
#
class Part
  attr_reader :notes, :dynamic_profile
  
  def initialize notes: [], dynamic_profile: Profile.new(Dynamics::MF)
    @notes = notes
    @dynamic_profile = dynamic_profile
    
    if dynamic_profile.changes_before?(0)
      raise ArgumentError, "dynamic profile has changes with offset less than 0"
    end
    
    d = self.duration
    if dynamic_profile.changes_after?(d)
      raise ArgumentError, "dynamic profile has changes with offset greater than part duration #{d}"
    end
  end
  
  # Produce an exact copy of the current object
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  # Compare the equality of another Part object.
  def ==(other)
    return (@notes == other.notes) &&
    (@dynamic_profile == other.dynamic_profile)
  end

  # Duration of part notes.
  def duration
    return @notes.inject(0) { |sum, note| sum + note.duration }
  end
  
  def transpose pitch_diff
    self.clone.transpose! pitch_diff
  end

  def transpose! pitch_diff
    @notes[0...-1].each do |note|
      note.transpose_pitches_and_links! pitch_diff
    end
    @notes[-1].transpose_pitches_only! pitch_diff
    return self
  end
  
  # Add on notes and dynamic_profile from another part, producing a new
  # Part object. The offsets of value changes in the dynamic profile,
  # for the other part, will be considered relative from end of current part.
  def append other
    self.clone.append! other
  end
  
  # Add on notes and dynamic_profile from another part, producing a new
  # Part object. The offsets of value changes in the dynamic profile,
  # for the other part, will be considered relative from end of current part.
  def append! other
    d = self.duration
    @dynamic_profile.merge_changes!(d => Change::Immediate.new(other.dynamic_profile.start_value))
    @dynamic_profile.merge_changes!(other.dynamic_profile.shift(d).value_changes)
    
    @notes += other.notes.map {|x| x.clone}
    return self
  end
end

end
end
