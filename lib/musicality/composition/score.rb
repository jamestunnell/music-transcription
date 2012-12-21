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
  include HashMake
  attr_reader :parts, :beat_duration_profile, :beats_per_minute_profile, :program

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:beats_per_minute_profile, SettingProfile, ->(a){ a.values_positive? }),
               spec_arg(:program, Program) ]
  
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_array(:parts, Part),
               spec_arg(:beat_duration_profile, SettingProfile, ->(a){ a.values_positive? }, ->{ SettingProfile.new :start_value => 0.25 }) ]
  
  # A new instance of Score.
  # @param [Hash] args Hashed arguments. Required keys are :tempos and 
  #               :programs. Optional keys are :parts.
  def initialize args={}
    process_args args
  end
  
  # Set the score parts.
  # @param [Array] parts The score parts.
  # @raise [ArgumentError] if notes is not an Array.
  # @raise [ArgumentError] if parts contain a non-Part object.
  def parts= parts
    raise ArgumentError, "parts is not an Array" if !parts.is_a?(Array)

    parts.each do |part|
      raise ArgumentError, "parts contain a non-Part #{part}" if !part.is_a?(Part)
    end
    
    @parts = parts
  end

  # Set the score beat duration SettingProfile.
  # @param [Tempo] beat_duration_profile The SettingProfile for beat duration.
  # @raise [ArgumentError] if beat_duration_profile is not a SettingProfile.
  def beat_duration_profile= beat_duration_profile
    raise ArgumentError, "beat_duration_profile is not a SettingProfile" unless beat_duration_profile.is_a?(SettingProfile)
    @beat_duration_profile = beat_duration_profile
  end
  
  # Set the score beats per minute SettingProfile.
  # @param [Tempo] beats_per_minute_profile The SettingProfile for beats per minute.
  # @raise [ArgumentError] if beats_per_minute_profile is not a SettingProfile.
  def beats_per_minute_profile= beats_per_minute_profile
    raise ArgumentError, "beats_per_minute_profile is not a SettingProfile" unless beats_per_minute_profile.is_a?(SettingProfile)
    @beats_per_minute_profile = beats_per_minute_profile
  end

  # Set the score program, which determines which defines sections and how they 
  # are played.
  # @param [Program] program The score program.
  # @raise [ArgumentError] if tempos is not a Program.
  def program= program
    raise ArgumentError, "program is not a Program" if !program.is_a?(Program)

  	@program = program
  end

  # Find the start of a score. The start will be at then start of whichever part begins
  # first, or 0 if no parts have been added.
  def find_start
    sos = 0.0
    
    @parts.each do |part|
      sop = part.find_start
      sos = sop if sop > sos
    end
    
    return sos
  end
  
  # Find the end of a score. The end will be at then end of whichever part ends 
  # last, or 0 if no parts have been added.
  def find_end
    eos = 0.0
    
    @parts.each do |part|
      eop = part.find_end
      eos = eop if eop > eos
    end
    
    return eos
  end
end

end
