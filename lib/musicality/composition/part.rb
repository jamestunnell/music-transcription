module Musicality

# Abstraction of a musical part. Contains note sequences, loudness settings, 
# instrument plugins, and effect plugins.
#
# @author James Tunnell
#
# @!attribute [rw] note_sequences
#   @return [Array] The note sequences to be played.
#
# @!attribute [rw] loudness_profile
#   @return [SettingProfile] The parts loudness profile.
#
# @!attribute [rw] instrument_plugins
#   @return [Array] An array of plugin configs that each describe an instrument
#                        plugin to be used in performing the part and settings to
#                        apply to the plugin.
#
# @!attribute [rw] effect_plugins
#   @return [Array] An array of plugin configs that each describe an effect
#                        plugin to be used in performing the part and settings to
#                        apply to the plugin.
#
# @!attribute [rw] id
#   @return [String] An identifying string, which should be different from other part IDs.
#
class Part
  include HashMake
  attr_reader :loudness_profile, :note_sequences#, :instrument_plugins, :effect_plugins, :id
  
  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [  ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg(:loudness_profile, SettingProfile, ->(a){ a.values_between?(0.0,1.0) }, SettingProfile.new(:start_value => 0.5)),
               spec_arg_array(:note_sequences, NoteSequence),
               #spec_arg_array(:instrument_plugins, PluginConfig),
               #spec_arg_array(:effect_plugins, PluginConfig),
               #spec_arg(:id, String, ->(a){true}, -> { UniqueToken.make_unique_string(8) })
              ]
  
  # A new instance of Part.
  # @param [Hash] args Hashed arguments. Valid optional keys are :loudness_profile, 
  #                    :note_sequences, :instrument_plugins, :effect_plugins, and :id.
  def initialize args = {}
    process_args args
  end
  
  # Set the part note sequences.
  # @param [Array] note_sequences Contains note sequences to be played.
  # @raise [ArgumentError] unless note_sequences is an Array.
  # @raise [ArgumentError] unless note_sequences contains only NoteSequence objects.
  def note_sequences= note_sequences
    raise ArgumentError, "note_seqeuences is not an Array" if !note_sequences.is_a?(Array)
    
    note_sequences.each do |note_seqeuence|
      raise ArgumentError, "note_seqeuences contain a non-NoteSequence" if !note_seqeuence.is_a?(NoteSequence)
    end
    
    @note_sequences = note_sequences
  end

  # Set the loudness SettingProfile.
  # @param [Tempo] loudness_profile The SettingProfile for part loudness.
  # @raise [ArgumentError] if loudness_profile is not a SettingProfile.
  def loudness_profile= loudness_profile
    raise ArgumentError, "loudness_profile is not a SettingProfile" unless loudness_profile.is_a?(SettingProfile)
    @loudness_profile = loudness_profile
  end

  ## Set the part's instrument plugin configs.
  ## 
  ## @param [PluginConfig] instrument_plugins An array of plugin configs that each
  ##                                          describe an instrument plugin to be
  ##                                          used in performing the part and
  ##                                          settings to apply to the plugin.
  ## @raise [ArgumentError] unless instrument_plugins is an Array.
  ## @raise [ArgumentError] unless each item in instrument_plugins is a PluginConfig.
  #def instrument_plugins= instrument_plugins
  #  
  #  raise ArgumentError, "instrument_plugins #{instrument_plugins} is not an Array" unless instrument_plugins.is_a?(Array)
  #  instrument_plugins.each do |instrument_plugin|
  #    raise ArgumentError, "instrument_plugin #{instrument_plugin} is not a PluginConfig" unless instrument_plugin.is_a?(PluginConfig)
  #  end
  #  
  #  @instrument_plugins = instrument_plugins
  #end
  #
  ## Set the part's effect plugin configs.
  ## 
  ## @param [PluginConfig] effect_plugins An array of plugin configs that each
  ##                                          describe an effect plugin to be
  ##                                          used in performing the part and
  ##                                          settings to apply to the plugin.
  ## @raise [ArgumentError] unless effect_plugins is an Array.
  ## @raise [ArgumentError] unless each item in effect_plugins is a PluginConfig.
  #def effect_plugins= effect_plugins
  #  
  #  raise ArgumentError, "effect_plugins #{effect_plugins} is not an Array" unless effect_plugins.is_a?(Array)
  #  effect_plugins.each do |effect_plugin|
  #    raise ArgumentError, "effect_plugin #{effect_plugin} is not a PluginConfig" unless effect_plugin.is_a?(PluginConfig)
  #  end
  #  
  #  @effect_plugins = effect_plugins
  #end
  #
  ## Set the part ID, which should be unique string among other parts
  ## in the same score.
  ##
  ## @param [String] id The part id string.
  ## @raise [ArgumentError] unless id is a String
  #def id= id
  #  raise ArgumentError, "id is not a String" unless id.is_a?(String)
  #  @id = id
  #end
  
  # Find the start of the part. The start will be at the note or 
  # note sequence that starts first, or 0 if none have been added.
  def find_start
    sop = 0.0
 
    @note_sequences.each do |sequence|
      sos = sequence.offset
      sop = sos if sos < sop
    end

    return sop
  end

  # Find the end of the part. The end will be at then end of whichever note or 
  # note sequence ends last, or 0 if none have been added.
  def find_end
    eop = 0.0
 
    @note_sequences.each do |sequence|
      eos = sequence.offset + sequence.duration
      eop = eos if eos > eop
    end

    return eop
  end

end

end
