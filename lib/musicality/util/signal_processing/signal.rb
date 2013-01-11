module Musicality

class Signal
  attr_reader :data, :window
  
  def initialize data
    @data = data    
  end
  
  def energy window_type = Window::WINDOW_RECTANGLE
    window = Window.new @data.count, window_type
    sum = 0.0
    
    for i in 0...@data.count do
      x = @data[i]
      sum += (x * x * window.data[i])
    end
    
    return sum
  end
  
  # includes stop index!
  def energy_between start_index, stop_index, window_type = Window::WINDOW_RECTANGLE
    data = @data[start_index, stop_index + 1]
    window = Window.new data.count, window_type

    sum = 0.0
    
    for i in 0...data.count do
      x = data[i]
      sum += (x * x * window.data[i])
    end
    
    return sum
  end
  
  # Determine how well the another signal (g) correlates to the current signal (f).
  # Correlation is determined at every point in f. The signal g must not be
  # longer than f. Correlation involves moving g along f and performing
  # convolution. Starting a the beginning of f, it continues until the end
  # of g hits the end of f. Doesn't actually convolve, though. Instead, it
  # adds 
  #
  # @param [Array] other_signal The signal to look for in the current signal.
  # @param [true/false] normalize Flag to indicate if normalization should be
  #                               performed on input signals (performed on a copy
  #                               of the original data).
  # @raise [ArgumentError] if other_signal is not a Signal or Array.
  # @raise [ArgumentError] if other_signal is longer than the current signal data.
  def cross_correlation other_signal, normalize = true
    if other_signal.is_a? Signal
      other_data = other_signal.data
    elsif other_signal.is_a? Array
      other_data = other_signal
    else
      raise ArgumentError, "other_signal is not a Signal or Array"
    end
    
    f = @data
    g = other_data
    
    raise ArgumentError, "g.count #{g.count} is greater than f.count #{f.count}" if g.count > f.count
    
    g_size = g.count
    f_size = f.count
    f_g_diff = f_size - g_size
    
    cross_correlation = []

    if normalize
      max = (f.max_by {|x| x.abs }).abs.to_f
      
      f = f.clone
      g = g.clone
      f.each_index {|i| f[i] =  f[i] / max }
      g.each_index {|i| g[i] =  g[i] / max }
    end

    #puts "f: #{f.inspect}"
    #puts "g: #{g.inspect}"

    for n in 0..f_g_diff do
      f_window = (n...(n + g_size)).entries
      g_window = (0...g_size).entries
      
      sample = 0.0
      for i in 0...f_window.count do
        i_f = f_window[i]
        i_g = g_window[i]
        
        #if use_relative_error
        target = g[i_g].to_f
        actual = f[i_f]
        
        #if target == 0.0 && actual != 0.0 && normalize
        #  puts "target is #{target} and actual is #{actual}"
        #  error = 1.0
        #else
          error = (target - actual).abs# / target
        #end
        
        sample += error
        
        #else
        #  sample += (f[i_f] * g[i_g])
        #end
      end
      
      cross_correlation << (sample)# / g_size.to_f)
    end
    
    return cross_correlation
  end
  
  def envelope attack_time, release_time, sample_rate
    raise ArgumentError, "attack_time #{attack_time } is less than or equal to zero" if attack_time <= 0.0
    raise ArgumentError, "release_time #{release_time} is less than or equal to zero" if release_time <= 0.0
    raise ArgumentError, "sample_rate #{sample_rate} is less than or equal to zero" if sample_rate <= 0.0
    
    g_attack = Math.exp(-1.0 / (sample_rate * attack_time))
    g_release = Math.exp(-1.0 / (sample_rate * release_time))
    
    envelope = Array.new(@data.count)
    envelope_current = 0.0
    
    for i in 0...@data.count do
      input_abs = @data[i].abs
      
      if envelope_current < input_abs
        envelope_current = (envelope_current * g_attack) + ((1.0 - g_attack) * input_abs)
      else
        envelope_current = (envelope_current * g_release) + ((1.0 - g_release) * input_abs)
      end
      
      envelope[i] =  envelope_current
    end
  end
end

end