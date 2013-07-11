require 'spcore'

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

  def plot_range x_range, x_step, title = "value computer plot over #{x_range}"
    xy_data = {}
    x_range.step(x_step).each do |x|
      xy_data[x] = value_at(x)
    end
    SPCore::Plotter.plot_2d(title => xy_data)
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
      m = (value.to_f - b.to_f) / duration.to_f
      
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
    start_value = @piecewise_function.eval offset
    end_value = value_change.value
    value_diff = end_value - start_value
    duration = value_change.transition.duration
    domain = offset.to_f..domain_max
    
    if duration == 0
      func = lambda {|x| end_value }
    else
      tanh_domain = -5..5
      tanh_range = Math::tanh(tanh_domain.first)..Math::tanh(tanh_domain.last)
      tanh_span = tanh_range.last - tanh_range.first

      func = lambda do |x|
        raise RangeError, "#{x} is not in the domain" if !domain.include?(x)
          if x < (domain.first + duration)
            start_domain = domain.first...(domain.first + duration)
            x2 = transform_domains(start_domain, tanh_domain, x)
            y = Math::tanh x2
            z = (y / tanh_span) + 0.5 # ranges from 0 to 1
            start_value + (z * value_diff)
          else
            end_value
          end
      end
    end
    @piecewise_function.add_piece domain, func
  end

  # x should be in the start domain 
  def transform_domains start_domain, end_domain, x
    perc = (x - start_domain.first) / (start_domain.last - start_domain.first).to_f
    x2 = perc * (end_domain.last - end_domain.first) + end_domain.first
  end
end

end
