module Musicality

# Compute the value of a Profile for any offset.
# @author James Tunnell
#
# @!attribute [r] piecewise_function
#   @return [PiecewiseFunction] A piecewise function that can calculate the 
#                               value for any valid offset.
#
class ValueComputer
  attr_reader :piecewise_function

  def initialize setting_profile
    @piecewise_function = Musicality::PiecewiseFunction.new
    set_default_value setting_profile.start_value
    
    if setting_profile.value_changes.any?
      setting_profile.value_changes.sort.each do |pair|
        offset = pair.first
        value_change = pair.last
        
        case value_change .transition.type
        when Transition::IMMEDIATE
          add_immediate_change value_change, offset
        when Transition::LINEAR
          add_linear_change value_change, offset
        when Transition::SIGMOID
          add_sigmoid_change value_change, offset
        end
        
      end
    end
  end

  # Compute the value at the given offset.
  # @param [Numeric] offset The given offset to compute value at.
  def value_at offset
    @piecewise_function.eval offset
  end
  
  # finds the minimum domain value
  def domain_min
    Musicality::MIN_OFFSET
  end

  # finds the maximum domain value
  def domain_max
    Musicality::MAX_OFFSET
  end
  
  # finds the minimum domain value
  def self.domain_min
    Musicality::MIN_OFFSET
  end

  # finds the maximum domain value
  def self.domain_max
    Musicality::MAX_OFFSET
  end
  
  private

  def set_default_value value
    func = lambda {|x| value }
    @piecewise_function.add_piece( domain_min..domain_max, func )
  end

  # Add a function piece to the piecewise function, which will to compute value
  # for a matching note offset. Transition duration will be ignored since the
  # change is immediate.
  #
  # @param [ValueChange] value_change An event with information about the new value.
  # @param [Numeric] offset
  def add_immediate_change value_change, offset
    func = nil
    value = value_change.value
    domain = offset..domain_max
    func = lambda {|x| value }
    
    @piecewise_function.add_piece domain, func
  end
    
  # Add a function piece to the piecewise function, which will to compute value
  # for a matching note offset. If the dynamic event duration is non-zero, a 
  # linear transition function is created.
  #
  # @param [ValueChange] value_change An event with information about the new value.
  # @param [Numeric] offset
  def add_linear_change value_change, offset
    
    func = nil
    value = value_change.value
    duration = value_change.transition.duration
    domain = offset..domain_max
    
    if duration == 0
      func = lambda {|x| value }
    else
      b = @piecewise_function.eval domain.first
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

  # Add a function piece to the piecewise function, which will to compute value
  # for a matching note offset. If the dynamic event duration is non-zero, a 
  # linear transition function is created.
  #
  # @param [ValueChange] value_change An event with information about the new value.
  # @param [Numeric] offset
  def add_sigmoid_change value_change, offset
    
    func = nil
    value = value_change.value
    duration = value_change.transition.duration
    domain = offset..domain_max
    
    if duration == 0
      func = lambda {|x| value }
    else
      # TODO - replace with sigmoid-like function
      
      #b = @piecewise_function.eval domain.first
      #m = (value - b) / duration
      #
      #func = lambda do |x|
      #  raise RangeError, "#{x} is not in the domain" if !domain.include?(x)
      #  
      #  if x < (domain.first + duration)
      #    (m * (x - domain.first)) + b
      #  else
      #    value
      #  end
      #end
    end
    
    @piecewise_function.add_piece domain, func
  end

end

end
