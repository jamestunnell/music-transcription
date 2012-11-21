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
  
  def initialize value_computer, start_offset
    raise ArgumentError, "value_computer is not a ValueComputer" unless value_computer.is_a?(ValueComputer)
    @value_computer = value_computer
    reset start_offset
  end
  
  def reset start_offset
    @value = @value_computer.value_at start_offset
  end
end

end
