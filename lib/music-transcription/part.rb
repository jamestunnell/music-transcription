require 'yaml'

module Music
module Transcription

# Abstraction of a musical part. Contains start offset, notes, and loudness_profile settings.
#
# @author James Tunnell
#
# @!attribute [rw] offset
#   @return [Numeric] The offset where the part begins.
#
# @!attribute [rw] notes
#   @return [Array] The notes to be played.
#
# @!attribute [rw] loudness_profile
#   @return [Profile] The parts loudness_profile profile.
#
class Part
  include Hashmake::HashMakeable
  attr_reader :offset, :loudness_profile, :notes
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :offset => arg_spec(:reqd => false, :type => Numeric, :default => 0),
    :loudness_profile => arg_spec(:reqd => false, :type => Profile, :validator => ->(a){ a.values_between?(0.0,1.0) }, :default => ->(){ Profile.new(:start_value => 0.5) }),
    :notes => arg_spec_array(:reqd => false, :type => Note),
  }
  
  # A new instance of Part.
  # @param [Hash] args Hashed arguments. Valid optional keys are :loudness_profile, 
  #                    :notes, and :offset.
  def initialize args = {}
    hash_make args, Part::ARG_SPECS
  end
  
  # Produce an exact copy of the current object
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  # Compare the equality of another Part object.
  def ==(other)
    return (@offset == other.offset) &&
    (@loudness_profile == other.loudness_profile) &&
    (@notes == other.notes)
  end

  # Set the start offset of the part.
  # @param [Numeric] offset The start offset of the part.
  # @raise [ArgumentError] unless offset is a Numeric.
  def offset= offset
    ARG_SPECS[:offset].validate_value offset
    @offset = offset
  end

  # Set the loudness_profile Profile.
  # @param [Tempo] loudness_profile The Profile for part loudness_profile.
  # @raise [ArgumentError] if loudness_profile is not a Profile.
  def loudness_profile= loudness_profile
    ARG_SPECS[:loudness_profile].validate_value loudness_profile
    @loudness_profile = loudness_profile
  end

  # Duration of part notes.
  def duration
    total_duration = @notes.inject(0) { |sum, note| sum + note.duration }
    return @offset + total_duration
  end
  
  # offset where part begins
  def start
    return @offset
  end

  # offset where part ends
  def end
    return @offset + duration
  end
  
  def transpose pitch_diff
    self.clone.transpose! pitch_diff
  end

  def transpose! pitch_diff
    @notes.each do |note|
      note.transpose! pitch_diff
    end
    return self
  end 
end

class PartFile < Part
  include Hashmake::HashMakeable
  attr_reader :file_path
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :file_path => arg_spec(:reqd => true, :type => String, :validator => ->(a){ File.exist? a })
  }
  
  # A new instance of Part.
  # @param [Hash] args Hashed arguments. Only valid keys is :file_path.
  def initialize args
    hash_make args, PartFile::ARG_SPECS
    
    unless @file_path.nil?
      obj = YAML.load_file @file_path
      
      if obj.is_a?(Part)
        super(:offset => obj.offset, :notes => obj.notes, :loudness_profile => obj.loudness_profile)
      elsif obj.is_a?(Hash)
        super(obj)
      else
        raise ArgumentError, "Expected a Hash or Part object"
      end
    end
  end

  # Produce an exact copy of the current object
  def clone
    Marshal.load(Marshal.dump(self))
  end

end

end
end
