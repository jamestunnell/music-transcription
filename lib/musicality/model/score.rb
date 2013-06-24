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
  attr_reader :parts, :tempo_profile, :program

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :parts => arg_spec_hash(:reqd => false, :type => Part),
    :program => arg_spec(:reqd => false, :type => Program, :allow_nil => true, :default => nil),
    :tempo_profile => arg_spec(:reqd => false, :type => Profile, :allow_nil => true, :default => nil, :validator => ->(a){ a.values_positive? }),
  }
  
  # A new instance of Score.
  # @param [Hash] args Hashed arguments. Required keys are :tempos and 
  #               :programs. Optional keys are :parts.
  def initialize args={}
    hash_make ARG_SPECS, args
  end
  
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  # Compare the equality of another Score object.
  def ==(other)
    return (@tempo_profile == other.tempo_profile) &&
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

  # Set the score tempo Profile.
  # @param [Profile] tempo_profile The tempo profile for the score.
  # @raise [ArgumentError] if tempo_profile is not a Profile.
  def tempo_profile= tempo_profile
    validate_arg ARG_SPECS[:tempo_profile], tempo_profile
    @tempo_profile = tempo_profile
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
