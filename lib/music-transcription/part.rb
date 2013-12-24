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
# @!attribute [r] loudness_profile
#   @return [Profile] The parts loudness_profile profile.
#
class Part
  attr_reader :loudness_profile, :notes
  
  def initialize notes: [], loudness_profile: Profile.new(0.5)
    @notes = notes
    @loudness_profile = loudness_profile
  end
  
  # Produce an exact copy of the current object
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  # Compare the equality of another Part object.
  def ==(other)
    return (@notes == other.notes) &&
    (@loudness_profile == other.loudness_profile)    
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
end

end
end
