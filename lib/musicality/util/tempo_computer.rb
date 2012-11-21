module Musicality

# Computer tempo at any offset. Uses ValueComputer base class to perform computation.
#
# @author James Tunnell
#
class TempoComputer < ValueComputer
  
  # A new instance of TempoComputer.
  # @param [Tempo] start_tempo The tempo to use at start.
  # @param [Array] tempo_changes An array of tempo events.
  # @raise [ArgumentError] if start_tempo is not a Tempo.
  # @raise [ArgumentError] if any of tempo_changes is not a Tempo.
  def initialize start_tempo, tempo_changes = []
    raise ArgumentError, "start_tempo is not a Tempo" if !start_tempo.is_a?(Tempo)

    default_value = start_tempo.notes_per_second
    value_change_events = []
    tempo_changes.each do |tempo_change|
      raise ArgumentError, "tempo_change #{tempo_change} is not a Tempo" unless tempo_change.is_a?(Tempo)
      value_change_events << Event.new(tempo_change.offset, tempo_change.notes_per_second, tempo_change.duration)
    end
    
    super(default_value, value_change_events)
  end
  
  # Compute the tempo in notes per second at the given offset.
  # @param [Numeric] offset The given offset to compute tempo at.
  def notes_per_second_at offset
    value_at offset
  end
end

end
