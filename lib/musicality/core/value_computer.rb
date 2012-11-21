module Musicality

# @author James Tunnell
#
# @!attribute [r] piecewise_function
#   @return [PiecewiseFunction] A piecewise function that can calculate the 
#                               value for any valid offset.
#
class ValueComputer
  attr_reader :piecewise_function

  def initialize default_value, value_change_events = []
    @piecewise_function = Musicality::PiecewiseFunction.new
    set_default_value default_value
    
    if value_change_events.any?
      value_change_events = value_change_events.sort_by {|a| a.offset }
        
      value_change_events.each do |event|
        add_value_change event
      end
    end
  end

  # Compute the value at the given offset.
  # @param [Numeric] offset The given offset to compute value at.
  def value_at offset
    @piecewise_function.evaluate_at offset
  end
  
  # finds the minimum domain value
  def domain_min
    Event::MIN_OFFSET
  end

  # finds the maximum domain value
  def domain_max
    Event::MAX_OFFSET
  end
  
  private

  def set_default_value value
    func = lambda {|x| value }
    @piecewise_function.add_piece( (Event::MIN_OFFSET)...(Event::MAX_OFFSET + 1), func )
  end

  # Add a function piece to the piecewise function, which will to compute dynamic
  # for a matching note offset. If the dynamic event duration is non-zero, a 
  # linear transition function is created.
  #
  # @param [Numeric] value The new value.
  # @param [Numeric] offset The offset where the new value takes effect.
  # @param [Numeric] duration The duration (if any) of a transition to the new value.
  def add_value_change value_change_event
    
    func = nil
    offset = value_change_event.offset
    value = value_change_event.value
    duration = value_change_event.duration
    domain = offset...(Event::MAX_OFFSET + 1)
    
    if duration == 0
      func = lambda {|x| value }
    else
      b = @piecewise_function.evaluate_at domain.first
      m = (value - b) / duration
      
      func = lambda do |x|
        raise RangeError, "#{x} is not in the domain" if !domain.include?(x)
        
        if x < (domain.first + duration)
          (m * (x - domain.first)) + b
        else
          value
        end
      end
    end
    
    @piecewise_function.add_piece domain, func
  end

end

end
