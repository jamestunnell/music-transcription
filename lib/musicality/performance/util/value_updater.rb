require 'publisher'

module Musicality

# For a given value computer, recomputes value when needed and notifies observers.
#
# @author James Tunnell
class ValueUpdater
  extend Publisher
  
  can_fire :value_changed
  
  attr_reader :value
  
  # Given an offset, update the current value and fire :settingd notification.
  def update_value offset
    value = @value_computer.value_at offset
    
    if value != @value
      @value = value
      fire :value_changed, @value
    end
  end
  
  # A new instance of ValueUpdater.
  def initialize value_computer, start_offset
    raise ArgumentError, "value_computer is not a ValueComputer" unless value_computer.is_a?(ValueComputer)
    @value_computer = value_computer
    reset start_offset
  end
  
  # Reset the current value using the given offset. Don't fire any notification.
  def reset start_offset
    @value = @value_computer.value_at start_offset
  end
end

end
