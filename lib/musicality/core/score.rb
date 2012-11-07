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
# @!attribute [rw] program
#   @return [Array] Score program.
#
class Score
  include HashMake
  attr_reader :parts, :tempos, :program

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg_array(:tempos, Tempo),
               spec_arg(:program, Program) ]
  
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_array(:parts, Part, []) ]
  
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

  # Set the score tempos.
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

  # Set the score program, which determines which defines sections and how they 
  # are played.
  # @param [Program] program The score program.
  # @raise [ArgumentError] if tempos is not a Program.
  def program= program
    raise ArgumentError, "program is not a Program" if !program.is_a?(Program)

  	@program = program
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
