module Musicality

# Abstraction of a musical score. Contains parts, notes, note sequences, dynamics,
# and tempos.
#
# @author James Tunnell
#
# @!attribute [rw] parts
#   @return [Hash] Maps parts to instruments (by name).
# 
# @!attribute [rw] tempos
#   @return [Hash] Maps tempos to offsets (in note duration).
#
class Score < Part

  attr_reader :parts, :tempos
  
  # A new instance of Score.
  # @param [Hash] options Optional arguments. Valid keys are :parts, :notes, 
  #               :note_sequences, :dynamics, :tempos
  def initialize options={}
    opts = {
      :parts => {},
      :tempos => {}
    }.merge options
	  
	  super opts

	  self.parts = opts[:parts]
    self.tempos = opts[:tempos]
  end
  
  # Set the score parts.
  # @param [Hash] parts The parts, mapped to instruments (by name).
  # @raise [ArgumentError] if notes is not a Hash.
  # @raise [ArgumentError] if parts contain a non-Part object.
  def parts= parts
    raise ArgumentError, "parts is not a Hash" if !parts.is_a?(Hash)

    parts.values.each do |part|
      raise ArgumentError, "parts contain a non-Part #{part}" if !part.is_a?(Part)
    end
    
    @parts = parts
  end

  # Set the part tempos.
  # @param [Hash] tempos The tempos, mapped to offsets (in note duration).
  # @raise [ArgumentError] if tempos is not a Hash.
  # @raise [ArgumentError] if tempos contain a non-Tempo object.
  def tempos= tempos
    raise ArgumentError, "tempos is not a Hash" if !tempos.is_a?(Hash)

    tempos.values.each do |tempo|
      raise ArgumentError, "tempos contain a non-Tempo #{tempo}" if !tempo.is_a?(Tempo)
    end
    
  	@tempos = tempos
  end

end

end
