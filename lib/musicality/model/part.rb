require 'hashmake'
require 'yaml'

module Musicality

# Abstraction of a musical part. Contains start offset, notes, and loudness_profile settings.
#
# @author James Tunnell
#
# @!attribute [rw] notes
#   @return [Array] The notes to be played.
#
# @!attribute [rw] loudness_profile
#   @return [Profile] The parts loudness_profile profile.
#
class Part
  include Hashmake::HashMakeable
  attr_reader :start_offset, :loudness_profile, :notes
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :start_offset => arg_spec(:reqd => false, :type => Numeric, :default => 0),
    :loudness_profile => arg_spec(:reqd => false, :type => Profile, :validator => ->(a){ a.values_between?(0.0,1.0) }, :default => ->(){ Profile.new(:start_value => 0.5) }),
    :notes => arg_spec_array(:reqd => false, :type => Note),
    :file_path => arg_spec(:reqd => false, :type => String, :validator => ->(a){ File.exist? a }, :default => nil, :allow_nil => true)
  }
  
  # A new instance of Part.
  # @param [Hash] args Hashed arguments. Valid optional keys are :loudness_profile, 
  #                    :notes, and :start_offset.
  def initialize args = {}
    hash_make ARG_SPECS, args
    
    unless @file_path.nil?
      obj = YAML.load_file @file_path
      
      if obj.is_a?(Part)
        obj = obj.make_hash
      elsif !obj.is_a?(Hash)
        raise ArgumentError, "Expected a Hash or Part object"
      end
      
      hash_make ARG_SPECS, obj
    end
  end

  # Compare the equality of another Part object.
  def ==(other)
    return (@start_offset == other.start_offset) &&
    (@loudness_profile == other.loudness_profile) &&
    (@notes == other.notes)
  end

  # Set the start offset of the part.
  # @param [Numeric] start_offset The start offset of the part.
  # @raise [ArgumentError] unless start_offset is a Numeric.
  def start_offset= start_offset
    validate_arg ARG_SPECS[:start_offset], start_offset
    @start_offset = start_offset
  end

  # Set the loudness_profile Profile.
  # @param [Tempo] loudness_profile The Profile for part loudness_profile.
  # @raise [ArgumentError] if loudness_profile is not a Profile.
  def loudness_profile= loudness_profile
    validate_arg ARG_SPECS[:loudness_profile], loudness_profile
    @loudness_profile = loudness_profile
  end
  
  # Calculate and return the end offset of the part.
  def end_offset
    total_duration = @notes.inject(0) { |sum, note| sum + note.duration }
    return start_offset + total_duration
  end

end

end
