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
  # @param [Tempo] start_tempo The tempo to use at start.
  # @param [Array] tempo_changes An array of tempo events.
  # @raise [ArgumentError] if start_tempo is not a Tempo.
  # @raise [ArgumentError] if any of tempo_changes is not a Tempo.
  # @raise [ArgumentError] if the starting tempo has a non-zero duration.
  def initialize start_tempo, tempo_changes = []
    raise ArgumentError, "start_tempo is not a Tempo" if !start_tempo.is_a?(Tempo)
    raise ArgumentError, "starting tempo cannot have a non-zero event duration" if start_tempo.duration != 0
    
    @piecewise_function = Musicality::PiecewiseFunction.new
    set_default_tempo start_tempo
    
    if tempo_changes.any?
      tempo_changes = Event.hash_events_by_offset tempo_changes
      sorted_tempo_change_offsets = tempo_changes.keys.sort
        
      for i in 0...sorted_tempo_change_offsets.count do
        offset = sorted_tempo_change_offsets[i]
        tempo = tempo_changes[offset]
        
        if offset < start_tempo.offset
          add_to_piecewise_function tempo, tempo.offset...start_tempo.offset
        else
          add_to_piecewise_function tempo, tempo.offset...(Event::MAX_OFFSET + 1)
        end
      end
    end
  end
  
  # Compute the tempo in notes per second at the given note offset.
  # @param [Rational] note_offset The given note offset to compute tempo at.
  def notes_per_second_at note_offset
    @piecewise_function.evaluate_at note_offset
  end
  
  private

  def set_default_tempo tempo
    notes_per_sec = (tempo.beats_per_minute / 60.0) * tempo.beat_duration
    func = lambda {|x| notes_per_sec }
    @piecewise_function.add_piece (Event::MIN_OFFSET)...(Event::MAX_OFFSET + 1), func
  end

  # Add a function piece to the piecewise function, which will to compute tempo
  # for a matching note offset. If the tempo event duration is non-zero, a 
  # linear transition function is created.
  #
  # @param [Tempo] tempo The Tempo object which contains offset, duration, and
  #                      tempo information.
  def add_to_piecewise_function tempo, domain
    
    notes_per_sec = (tempo.beats_per_minute / 60.0) * tempo.beat_duration
    func = nil
    
    if tempo.duration == 0
      func = lambda {|x| notes_per_sec }
    else
      b = @piecewise_function.evaluate_at domain.first
      m = (notes_per_sec - b) / tempo.duration
      
      func = lambda do |x|
        raise RangeError, "#{x} is not in the domain" if !domain.include?(x)
        
        if x < (domain.first + tempo.duration)
          (m * (x - domain.first)) + b
        else
          notes_per_sec
        end
      end
    end
    
    @piecewise_function.add_piece domain, func
  end
end

end
