module Musicality

# Abstraction of a musical part. Contains note sequences, dynamics, and the 
# instrument spec.
#
# @author James Tunnell
#
# @!attribute [rw] sequences
#   @return [Array] The note sequences to be played.
#
# @!attribute [rw] dynamics
#   @return [Array] The dynamics which control part loudness.
#
# @!attribute [rw] instrument
#   @return [Instrument] The instrument to be used in playing the part.
#
class Part

  attr_reader :sequences, :dynamics, :instrument

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :sequences, :dynamics, :instrument ]  
  # default values for optional hashed arguments
  OPTIONAL_ARG_DEFAULTS = { :sequences => [], :dynamics => [],
                      :instrument => Instrument.new }
                      
  # A new instance of Part.
  # @param [Hash] options Optional arguments. Valid keys are :sequences, 
  #                       :dynamics, and :instrument.
  def initialize options = {}
    opts = OPTIONAL_ARG_DEFAULTS.merge options
    self.sequences = opts[:sequences]	
    self.dynamics = opts[:dynamics]
    self.instrument = opts[:instrument]
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
