require 'publisher'

module Musicality

# Recomputes value when needed and notifies observers.
class ValueUpdater
  extend Publisher
  
  can_fire :value_changed
  
  attr_reader :value
  
  def update_value offset
    value = @value_computer.value_at offset
    
    if value != @value
      @value = value
      fire :value_changed, @value
    end
  end
  
  def initialize default_value, value_change_events, start_offset
    @value_computer = ValueComputer.new default_value, value_change_events
    reset start_offset
  end
  
  def reset start_offset
    @value = @value_computer.value_at start_offset
  end
end

end
