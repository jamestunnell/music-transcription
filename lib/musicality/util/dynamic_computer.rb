module Musicality

# Computer dynamic at any offset. Uses ValueComputer base class to perform computation.
#
# @author James Tunnell
#
class DynamicComputer < ValueComputer
  
  # A new instance of DynamicComputer.
  # @param [Tempo] start_dynamic The dynamic to use at start.
  # @param [Array] dynamic_changes An array of dynamic events.
  # @raise [ArgumentError] if start_dynamic is not a Tempo.
  # @raise [ArgumentError] if any of dynamic_changes is not a Tempo.
  def initialize start_dynamic, dynamic_changes = []
    raise ArgumentError, "start_dynamic is not a Dynamic" unless start_dynamic.is_a?(Dynamic)

    default_value = start_dynamic.loudness
    value_change_events = []
    dynamic_changes.each do |dynamic_change|
      raise ArgumentError, "dynamic_change #{dynamic_change} is not a Dynamic" unless dynamic_change.is_a?(Dynamic)
      value_change_events << Event.new(dynamic_change.offset, dynamic_change.loudness, dynamic_change.duration)
    end
    
    super(default_value, value_change_events)
  end
  
  # Compute the dynamic loudness at the given offset.
  # @param [Numeric] offset The given offset to compute dynamic at.
  def loudness_at offset
    value_at offset
  end
end

end
