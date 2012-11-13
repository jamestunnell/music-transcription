module Musicality

# Abstraction of a musical score. Contains parts, notes, note sequences, dynamics,
# and tempos.
#
# @author James Tunnell
#
# @!attribute [rw] parts
#   @return [Array] Score parts.
# 
# @!attribute [rw] start_tempo
#   @return [Tempo] The starting score tempo.
#
# @!attribute [rw] tempo_changes
#   @return [Array] Changes in the score tempo.
#
# @!attribute [rw] program
#   @return [Array] Score program.
#
class Score
  include HashMake
  attr_reader :parts, :start_tempo, :tempo_changes, :program

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:start_tempo, Tempo),
               spec_arg(:program, Program) ]
  
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_array(:parts, Part, ->{ Array.new }),
               spec_arg_array(:tempo_changes, Tempo, ->{ Array.new }) ]
  
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

  # Set the score starting tempo.
  # @param [Tempo] start_tempo The score starting tempo.
  # @raise [ArgumentError] if tempo is not a Tempo object.
  def start_tempo= start_tempo
    raise ArgumentError, "start_tempo is not a Tempo" if !start_tempo.is_a?(Tempo)
  	@start_tempo = start_tempo
  end
  
  # Set the score tempo changes.
  # @param [Array] tempo_changes The score tempo changes.
  # @raise [ArgumentError] if tempo_changes is not an Array.
  # @raise [ArgumentError] if tempo_changes contain a non-Tempo object.
  def tempo_changes= tempo_changes
    raise ArgumentError, "tempo_changes is not an Array" if !tempo_changes.is_a?(Array)

    tempo_changes.each do |tempo|
      raise ArgumentError, "tempo_changes contain a non-Tempo #{tempo}" if !tempo.is_a?(Tempo)
    end
    
  	@tempo_changes = tempo_changes
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
