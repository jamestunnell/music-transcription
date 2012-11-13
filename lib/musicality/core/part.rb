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
# @!attribute [rw] instrument
#   @return [Instrument] The instrument to be used in playing the part.
#
class Part
  include HashMake
  attr_reader :sequences, :start_dynamic, :dynamic_changes, :instrument
  
  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:start_dynamic, Dynamic) ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_array(:sequences, Sequence, ->{ Array.new }),
               spec_arg_array(:dynamic_changes, Dynamic, ->{ Array.new }),
               spec_arg(:instrument, Instrument, ->{ Instrument.new }) ]
  
  # A new instance of Part.
  # @param [Hash] args Hashed arguments. Valid optional keys are :sequences, 
  #                    :dynamics, and :instrument.
  def initialize args = {}
    process_args args
  end
  
  # Set the part note sequences.
  # @param [Array] sequences Contains note sequences to be played.
  # @raise [ArgumentError] if sequences is not an Array.
  # @raise [ArgumentError] if sequences contain a non-Sequence objects.
  def sequences= sequences
    raise ArgumentError, "seqeuences is not an Array" if !sequences.is_a?(Array)
    
    sequences.each do |seqeuence|
      raise ArgumentError, "seqeuences contain a non-Sequence" if !seqeuence.is_a?(Sequence)
    end
    
    @sequences = sequences
  end

  # Set the part starting dynamic.
  # @param [Dynamic] start_dynamic The part starting dynamic.
  # @raise [ArgumentError] if start_dynamic is not a Dynamic object.
  def start_dynamic= start_dynamic
    raise ArgumentError, "start_dynamic is not a Dynamic" if !start_dynamic.is_a?(Dynamic)
    @start_dynamic = start_dynamic
  end
  
  # Set the part dynamic changes.
  # @param [Array] dynamic_changes The score dynamic changes.
  # @raise [ArgumentError] if dynamic_changes is not an Array.
  # @raise [ArgumentError] if dynamic_changes contain a non-Dynamic object.
  def dynamic_changes= dynamic_changes
    raise ArgumentError, "dynamic_changes is not an Array" if !dynamic_changes.is_a?(Array)

    dynamic_changes.each do |dynamic|
      raise ArgumentError, "dynamic_changes contain a non-Dynamic #{dynamic}" if !dynamic.is_a?(Dynamic)
    end
    
  	@dynamic_changes = dynamic_changes
  end

  # Set the part dynamics.
  # @param [Array] dynamics The part dynamics.
  # @raise [ArgumentError] if dynamics is not an Array.
  # @raise [ArgumentError] if dynamics contain a non-Dynamic object.
  def dynamics= dynamics
    raise ArgumentError, "dynamics is not an Array" if !dynamics.is_a?(Array)
  	
    dynamics.each do |dynamic|
      raise ArgumentError, "dynamics contain a non-Dynamic #{dynamic}" if !dynamic.is_a?(Dynamic)
    end
      	
    @dynamics = dynamics
  end

  # Set the part instrument.
  # @param [Instrument] instrument The instrument to be used in playing the part.
  # @raise [ArgumentError] if instrument is not an Instrument.
  def instrument= instrument
    raise ArgumentError, "instrument is not an Instrument" if !instrument.is_a?(Instrument)
  	@instrument = instrument
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
