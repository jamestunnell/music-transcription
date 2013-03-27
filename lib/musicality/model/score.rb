require 'hashmake'

module Musicality

# Abstraction of a musical score. Contains parts, program, and tempo profiles.
#
# @author James Tunnell
#
# @!attribute [rw] parts
#   @return [Array] Score parts.
# 
# @!attribute [rw] beat_duration_profile
#   @return [Tempo] The beat duration profile.
#
# @!attribute [rw] beats_per_minute_profile
#   @return [Array] The beats per minute profile.
#
# @!attribute [rw] program
#   @return [Array] Score program.
#
class Score
  include Hashmake::HashMakeable
  attr_reader :parts, :beat_duration_profile, :beats_per_minute_profile, :program

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :beats_per_minute_profile => arg_spec(:reqd => true, :type => SettingProfile, :validator => ->(a){ a.values_positive? }),
    :program => arg_spec(:reqd => true, :type => Program),
    :parts => arg_spec_hash(:reqd => false, :type => Part),
    :beat_duration_profile => arg_spec(:reqd => false, :type => SettingProfile, :validator => ->(a){ a.values_positive? }, :default => ->{ SettingProfile.new :start_value => 0.25 })
  }
  
  # A new instance of Score.
  # @param [Hash] args Hashed arguments. Required keys are :tempos and 
  #               :programs. Optional keys are :parts.
  def initialize args={}
    hash_make ARG_SPECS, args
  end
  
  # Compare the equality of another Score object.
  def ==(other)
    return (@beats_per_minute_profile == other.beats_per_minute_profile) &&
    (@beat_duration_profile == other.beat_duration_profile) &&
    (@program == other.program) &&
    (@parts == other.parts)
  end
  
  # Set the score parts.
  # @param [Hash] parts The score parts, mapped to IDs.
  # @raise [ArgumentError] if notes is not a Hash.
  # @raise [ArgumentError] if parts contain a non-Part object.
  def parts= parts
    validate_arg ARG_SPECS[:parts], parts
    @parts = parts
  end

  # Set the score beat duration SettingProfile.
  # @param [Tempo] beat_duration_profile The SettingProfile for beat duration.
  # @raise [ArgumentError] if beat_duration_profile is not a SettingProfile.
  def beat_duration_profile= beat_duration_profile
    validate_arg ARG_SPECS[:beat_duration_profile], beat_duration_profile
  end
  
  # Set the score beats per minute SettingProfile.
  # @param [Tempo] beats_per_minute_profile The SettingProfile for beats per minute.
  # @raise [ArgumentError] if beats_per_minute_profile is not a SettingProfile.
  def beats_per_minute_profile= beats_per_minute_profile
    validate_arg ARG_SPECS[:beats_per_minute_profile], beats_per_minute_profile
    @beats_per_minute_profile = beats_per_minute_profile
  end

  # Set the score program, which determines which defines sections and how they 
  # are played.
  # @param [Program] program The score program.
  # @raise [ArgumentError] if tempos is not a Program.
  def program= program
    validate_arg ARG_SPECS[:program], program
    @program = program
  end

  # Find the start of a score. The start will be at then start of whichever part begins
  # first, or 0 if no parts have been added.
  def find_start
    sos = 0.0
    
    @parts.each do |id,part|
      sop = part.start_offset
      sos = sop if sop > sos
    end
    
    return sos
  end
  
  # Find the end of a score. The end will be at then end of whichever part ends 
  # last, or 0 if no parts have been added.
  def find_end
    eos = 0.0
    
    @parts.each do |id,part|
      eop = part.end_offset
      eos = eop if eop > eos
    end
    
    return eos
  end
end

end
