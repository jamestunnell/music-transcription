module Musicality

# Abstraction of a musical part. Contains note sequences, dynamics, and the 
# instrument spec.
#
# @author James Tunnell
#
# @!attribute [rw] sequences
#   @return [Array] The note sequences to be played.
#
# @!attribute [rw] start_dynamic
#   @return [Dynamic] The starting part dynamic.
#
# @!attribute [rw] dynamic_changes
#   @return [Array] Changes in the part dynamic.
#
# @!attribute [rw] instrument_plugins
#   @return [Instrument] An array of plugin configs that each describe an instrument
#                        plugin to be used in performing the part and settings to
#                        apply to the plugin.
#
# @!attribute [rw] effect_plugins
#   @return [Instrument] An array of plugin configs that each describe an effect
#                        plugin to be used in performing the part and settings to
#                        apply to the plugin.
#
class Part
  include HashMake
  attr_reader :sequences, :start_dynamic, :dynamic_changes, :instrument_plugins, :effect_plugins, :id
  
  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:start_dynamic, Dynamic) ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_array(:sequences, Sequence, ->{ Array.new }),
               spec_arg_array(:dynamic_changes, Dynamic, ->{ Array.new }),
               spec_arg_array(:instrument_plugins, PluginConfig, ->{ Array.new }),
               spec_arg_array(:effect_plugins, PluginConfig, ->{ Array.new }),
               spec_arg(:id, String, -> { UniqueToken.make_unique_token(8) }) ]
  
  # A new instance of Part.
  # @param [Hash] args Hashed arguments. Valid optional keys are :sequences, 
  #                    :dynamics, and :instrument_plugin.
  def initialize args = {}
    process_args args
  end
  
  # Set the part note sequences.
  # @param [Array] sequences Contains note sequences to be played.
  # @raise [ArgumentError] unless sequences is an Array.
  # @raise [ArgumentError] unless sequences contains only Sequence objects.
  def sequences= sequences
    raise ArgumentError, "seqeuences is not an Array" if !sequences.is_a?(Array)
    
    sequences.each do |seqeuence|
      raise ArgumentError, "seqeuences contain a non-Sequence" if !seqeuence.is_a?(Sequence)
    end
    
    @sequences = sequences
  end

  # Set the part starting dynamic.
  # @param [Dynamic] start_dynamic The part starting dynamic.
  # @raise [ArgumentError] unless start_dynamic is a Dynamic object.
  def start_dynamic= start_dynamic
    raise ArgumentError, "start_dynamic is not a Dynamic" unless start_dynamic.is_a?(Dynamic)
    @start_dynamic = start_dynamic
  end
  
  # Set the part dynamic changes.
  # @param [Array] dynamic_changes The score dynamic changes.
  # @raise [ArgumentError] unless dynamic_changes is an Array.
  # @raise [ArgumentError] unless dynamic_changes contains only Dynamic objects.
  def dynamic_changes= dynamic_changes
    raise ArgumentError, "dynamic_changes is not an Array" unless dynamic_changes.is_a?(Array)

    dynamic_changes.each do |dynamic|
      raise ArgumentError, "dynamic_changes contain a non-Dynamic #{dynamic}" unless dynamic.is_a?(Dynamic)
    end
    
  	@dynamic_changes = dynamic_changes
  end

  # Set the part dynamics.
  # @param [Array] dynamics The part dynamics.
  # @raise [ArgumentError] unless dynamics is an Array.
  # @raise [ArgumentError] unless dynamics contains only Dynamic objects.
  def dynamics= dynamics
    raise ArgumentError, "dynamics is not an Array" unless dynamics.is_a?(Array)
  	
    dynamics.each do |dynamic|
      raise ArgumentError, "dynamics contain a non-Dynamic #{dynamic}" unless dynamic.is_a?(Dynamic)
    end
      	
    @dynamics = dynamics
  end

  # Set the part's instrument plugin configs.
  # 
  # @param [PluginConfig] instrument_plugins An array of plugin configs that each
  #                                          describe an instrument plugin to be
  #                                          used in performing the part and
  #                                          settings to apply to the plugin.
  # @raise [ArgumentError] unless instrument_plugins is an Array.
  # @raise [ArgumentError] unless each item in instrument_plugins is a PluginConfig.
  def instrument_plugins= instrument_plugins
    
    raise ArgumentError, "instrument_plugins #{instrument_plugins} is not an Array" unless instrument_plugins.is_a?(Array)
    instrument_plugins.each do |instrument_plugin|
      raise ArgumentError, "instrument_plugin #{instrument_plugin} is not a PluginConfig" unless instrument_plugin.is_a?(PluginConfig)
    end
    
    @instrument_plugins = instrument_plugins
  end

  # Set the part's effect plugin configs.
  # 
  # @param [PluginConfig] effect_plugins An array of plugin configs that each
  #                                          describe an effect plugin to be
  #                                          used in performing the part and
  #                                          settings to apply to the plugin.
  # @raise [ArgumentError] unless effect_plugins is an Array.
  # @raise [ArgumentError] unless each item in effect_plugins is a PluginConfig.
  def effect_plugins= effect_plugins
    
    raise ArgumentError, "effect_plugins #{effect_plugins} is not an Array" unless effect_plugins.is_a?(Array)
    effect_plugins.each do |effect_plugin|
      raise ArgumentError, "effect_plugin #{effect_plugin} is not a PluginConfig" unless effect_plugin.is_a?(PluginConfig)
    end
    
    @effect_plugins = effect_plugins
  end
  
  # Set the part ID, which should be unique string among other parts
  # in the same score.
  #
  # @param [String] id The part id string.
  # @raise [ArgumentError] unless id is a String
  def id= id
    raise ArgumentError, "id is not a String" unless id.is_a?(String)
    @id = id
  end
  
  # Find the start of the part. The start will be at the note or 
  # note sequence that starts first, or 0 if none have been added.
  def find_start
    sop = 0.0
 
    @sequences.each do |sequence|
      sos = sequence.offset
      sop = sos if sos < sop
    end

    return sop
  end

  # Find the end of the part. The end will be at then end of whichever note or 
  # note sequence ends last, or 0 if none have been added.
  def find_end
    eop = 0.0
 
    @sequences.each do |sequence|
      eos = sequence.offset + sequence.duration
      eop = eos if eos > eop
    end

    return eop
  end

end

end
