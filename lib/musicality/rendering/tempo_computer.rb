module Musicality

#
#
# @author James Tunnell
#
# @!attribute [r] piecewise_function
#   @return [PiecewiseFunction] A piecewise function that can calculate the 
#                               tempo in notes per second for any valid note offset.
#
class TempoComputer
  attr_reader :piecewise_function
  
  # A new instance of TempoComputer.
  # @param [Hash] tempos A hash that maps tempos to note offsets.
  # @raise [ArgumentError] if tempos is not a Hash.
  # @raise [ArgumentError] if there is no starting tempo (tempo at offset 0).
  # @raise [ArgumentError] if the starting tempo has a non-zero duration.
  def initialize tempos
    raise ArgumentError, "tempos is not a Hash" if !tempos.is_a?(Hash)
    raise ArgumentError, "there is no starting tempo (tempo at offset 0)" if tempos[0.to_r].nil?
    raise ArgumentError, "starting tempo cannot have a non-zero event duration" if tempos[0.to_r].duration != 0
    
    @piecewise_function = Musicality::PiecewiseFunction.new
    
    sorted_tempo_keys = tempos.keys.sort
    for i in 0...sorted_tempo_keys.count do
      tempo = tempos[sorted_tempo_keys[i]]
      add_to_piecewise_function tempo
    end
  end
  
  # Compute the tempo in notes per second at the given note offset.
  # @param [Rational] note_offset The given note offset to compute tempo at.
  def notes_per_second_at note_offset
    @piecewise_function.evaluate_at note_offset
  end

  private

  # Add a function piece to the piecewise function, which will to compute tempo
  # for a matching note offset. If the tempo event duration is non-zero, a 
  # linear transition function is created.
  #
  # @param [Tempo] tempo The Tempo object which contains offset, duration, and
  #                      tempo information.
  def add_to_piecewise_function tempo
    note_offset = tempo.offset
    raise RangeError, "tempo note offset is less than zero!" if note_offset < 0
    
    notes_per_sec = (tempo.beats_per_minute / 60.to_r) * tempo.beat_duration
    func = nil      
    
    if tempo.duration == 0
      func = lambda {|note_offset| notes_per_sec }
    else
      b = @piecewise_function.evaluate_at note_offset
      m = (notes_per_sec - b) / tempo.duration
      
      func = lambda do |x|
        raise RangeError, "#{x} is not in the domain" if x < note_offset
        
        if x < (note_offset + tempo.duration)
          ((m * (x - note_offset)) + b).to_r
        else
          notes_per_sec
        end
      end
    end
    
    @piecewise_function.add_piece note_offset...(Note::MAX_OFFSET + 1), func
  end
end

end
