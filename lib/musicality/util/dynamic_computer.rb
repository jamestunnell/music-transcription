module Musicality

#
#
# @author James Tunnell
#
# @!attribute [r] piecewise_function
#   @return [PiecewiseFunction] A piecewise function that can calculate the 
#                               dynamic loudness for any valid note offset.
#
class DynamicComputer
  attr_reader :piecewise_function
  
  # A new instance of DynamicComputer.
  # @param [Dynamic] start_dynamic The dynamic to use at start.
  # @param [Array] dynamic_changes An array of dynamic events.
  # @raise [ArgumentError] if start_dynamic is not a Dynamic.
  # @raise [ArgumentError] if any of dynamic_changes is not a Dynamic.
  # @raise [ArgumentError] if the starting dynamic has a non-zero duration.
  def initialize start_dynamic, dynamic_changes = []
    raise ArgumentError, "start_dynamic is not a Dynamic" if !start_dynamic.is_a?(Dynamic)
    raise ArgumentError, "starting dynamic cannot have a non-zero event duration" if start_dynamic.duration != 0
    
    @piecewise_function = Musicality::PiecewiseFunction.new
    set_default_dynamic start_dynamic
    
    if dynamic_changes.any?
      dynamic_changes = Event.hash_events_by_offset dynamic_changes
      sorted_dynamic_change_offsets = dynamic_changes.keys.sort
        
      for i in 0...sorted_dynamic_change_offsets.count do
        offset = sorted_dynamic_change_offsets[i]
        dynamic = dynamic_changes[offset]
        
        if offset < start_dynamic.offset
          add_to_piecewise_function dynamic, dynamic.offset...start_dynamic.offset
        else
          add_to_piecewise_function dynamic, dynamic.offset...(Event::MAX_OFFSET + 1)
        end
      end
    end
  end
  
  # Compute the dynamic loudness at the given note offset.
  # @param [Rational] note_offset The given note offset to compute dynamic at.
  def loudness_at note_offset
    @piecewise_function.evaluate_at note_offset
  end
  
  private

  def set_default_dynamic dynamic
    func = lambda {|x| dynamic.loudness }
    @piecewise_function.add_piece (Event::MIN_OFFSET)...(Event::MAX_OFFSET + 1), func
  end

  # Add a function piece to the piecewise function, which will to compute dynamic
  # for a matching note offset. If the dynamic event duration is non-zero, a 
  # linear transition function is created.
  #
  # @param [Dynamic] dynamic The Dynamic object which contains offset, duration, and
  #                      dynamic information.
  def add_to_piecewise_function dynamic, domain
    
    func = nil
    
    if dynamic.duration == 0
      func = lambda {|x| dynamic.loudness }
    else
      b = @piecewise_function.evaluate_at domain.first
      m = (dynamic.loudness - b) / dynamic.duration
      
      func = lambda do |x|
        raise RangeError, "#{x} is not in the domain" if !domain.include?(x)
        
        if x < (domain.first + dynamic.duration)
          (m * (x - domain.first)) + b
        else
          dynamic.loudness
        end
      end
    end
    
    @piecewise_function.add_piece domain, func
  end
end

end
