require 'hashmake'

module Musicality

# Abstraction of a musical part. Contains start offset, notes, and loudness settings.
#
# @author James Tunnell
#
# @!attribute [rw] notes
#   @return [Array] The notes to be played.
#
# @!attribute [rw] loudness_profile
#   @return [SettingProfile] The parts loudness profile.
#
class Part
  include Hashmake::HashMakeable
  attr_reader :start_offset, :loudness_profile, :notes
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :start_offset => arg_spec(:reqd => false, :type => Numeric, :default => 0),
    :loudness_profile => arg_spec(:reqd => false, :type => SettingProfile, :validator => ->(a){ a.values_between?(0.0,1.0) }, :default => ->(){ SettingProfile.new(:start_value => 0.5) }),
    :notes => arg_spec_array(:reqd => false, :type => Note),
  }
  
  # A new instance of Part.
  # @param [Hash] args Hashed arguments. Valid optional keys are :loudness_profile, 
  #                    :notes, and :start_offset.
  def initialize args = {}
    hash_make ARG_SPECS, args
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

  # Set the loudness SettingProfile.
  # @param [Tempo] loudness_profile The SettingProfile for part loudness.
  # @raise [ArgumentError] if loudness_profile is not a SettingProfile.
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
