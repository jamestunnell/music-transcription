require 'hashmake'

module Musicality

# Abstraction of a musical score. Contains parts and a program.
#
# @author James Tunnell
#
# @!attribute [rw] parts
#   @return [Array] Score parts.
# 
# @!attribute [rw] program
#   @return [Array] Score program.
#
class Score
  include Hashmake::HashMakeable
  attr_reader :parts, :program

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :parts => arg_spec_hash(:reqd => false, :type => Part),
    :program => arg_spec(:reqd => false, :type => Program, :default => ->(){ Program.new }),
  }
  
  # A new instance of Score.
  # @param [Hash] args Hashed arguments. Optional keys are :program and :parts.
  def initialize args={}
    hash_make args, ARG_SPECS
  end
  
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  # Compare the equality of another Score object.
  def ==(other)
    return (@program == other.program) &&
    (@parts == other.parts)
  end
  
  # Set the score parts.
  # @param [Hash] parts The score parts, mapped to IDs.
  # @raise [ArgumentError] if notes is not a Hash.
  # @raise [ArgumentError] if parts contain a non-Part object.
  def parts= parts
    Score::ARG_SPECS[:parts].validate_value parts
    @parts = parts
  end

  # Set the score program, which determines which defines sections and how they 
  # are played.
  # @param [Program] program The score program.
  # @raise [ArgumentError] if tempos is not a Program.
  def program= program
    Score::ARG_SPECS[:program].validate_value program
    @program = program
  end

  # Find the start of a score. The start will be at then start of whichever part begins
  # first, or 0 if no parts have been added.
  def start
    sos = 0.0
    
    @parts.each do |id,part|
      sop = part.start
      sos = sop if sop > sos
    end
    
    return sos
  end
  
  # Find the end of a score. The end will be at then end of whichever part ends 
  # last, or 0 if no parts have been added.
  def end
    eos = 0.0
    
    @parts.each do |id,part|
      eop = part.end
      eos = eop if eop > eos
    end
    
    return eos
  end
end

# Score with a tempo profile.
#
# @author James Tunnell
#
# @!attribute [rw] tempo_profile
#   @return [Profile] The tempo profile.
#
class TempoScore < Score
  include Hashmake::HashMakeable
  attr_reader :tempo_profile

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :tempo_profile => arg_spec(:reqd => true, :type => Profile, :validator => ->(a){ a.values_positive? }),
  }
  
  # A new instance of Score.
  # @param [Hash] args Hashed arguments. Required key is :tempo_profile.
  def initialize args={}
    hash_make args
    super(args)
  end
  
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  # Set the score tempo Profile.
  # @param [Profile] tempo_profile The tempo profile for the score.
  # @raise [ArgumentError] if tempo_profile is not a Profile.
  def tempo_profile= tempo_profile
    TempoScore::ARG_SPECS[:tempo_profile].validate_value tempo_profile
    @tempo_profile = tempo_profile
  end
end

end
