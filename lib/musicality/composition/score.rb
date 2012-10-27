module Musicality

# Abstraction of a musical score. Contains parts, notes, note sequences, dynamics,
# and tempos.
#
# @author James Tunnell
#
# @!attribute [rw] parts
#   @return [Array] Score parts.
# 
# @!attribute [rw] tempos
#   @return [Array] Score tempos.
#
class Score

  attr_reader :parts, :tempos

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :parts, :tempos ]  

  # default values for optional hashed arguments
  DEFAULT_OPTIONS = { :parts => [], :tempos => [] }
  
  # A new instance of Score.
  # @param [Hash] options Optional arguments. Valid keys are :parts, :tempos
  def initialize options={}
    opts = DEFAULT_OPTIONS.merge options
	  self.parts = opts[:parts]
    self.tempos = opts[:tempos]
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

  # Set the part tempos.
  # @param [Array] tempos The score tempos.
  # @raise [ArgumentError] if tempos is not an Array.
  # @raise [ArgumentError] if tempos contain a non-Tempo object.
  def tempos= tempos
    raise ArgumentError, "tempos is not an Array" if !tempos.is_a?(Array)

    tempos.each do |tempo|
      raise ArgumentError, "tempos contain a non-Tempo #{tempo}" if !tempo.is_a?(Tempo)
    end
    
  	@tempos = tempos
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
