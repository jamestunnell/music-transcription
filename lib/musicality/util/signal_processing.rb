require 'pry'

module Musicality

class SignalProcessing
  # For the given signals f and g, determine how well g correlates to f.
  # Correlation is determined at every point in f. The signal g must not be
  # longer than f. Correlation involves moving g along f and performing
  # convolution. Starting a the beginning of f, it continues until the end
  # of g hits the end of f. Doesn't actually convolve, though. Instead, it
  # adds 
  #
  # @param [Array] f The signal to look for g in.
  # @param [Array] g The signal to look for in f.
  # @param [true/false] normalize Flag to indicate if normalization should be
  #                               performed on input functions (does not
  #                               modify original input array).
  # @raise [ArgumentError] if g is longer than f.
  def self.cross_correlate f, g, normalize = true
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

  ## For the given signals f and g, determine how well g correlates to f.
  ## Correlation is determined at every point in f. The signal g must not be
  ## longer than f. Correlation involves moving g along f.
  ##
  ## @param [Array] f The signal to be correlated to.
  ## @param [Array] g The signal to correlate with f.
  ## @raise [ArgumentError] if g is longer than f.
  #def self.cross_correlate f, g
  #  raise ArgumentError, "g.count #{g.count} is greater than f.count #{f.count}" if g.count > f.count
  #  
  #  g_size = g.count
  #  g_size_div_2 = g_size / 2
  #  
  #  f_size = f.count
  #  f_g_diff = f_size - g_size
  #  
  #  #puts "f_size = #{f_size}"
  #  #puts "g_size = #{g_size}"
  #  #puts "g_size_div_2 = #{g_size_div_2}"
  #  #puts "f_g_diff = #{f_g_diff}"
  #  
  #  binding.pry
  #  
  #  cross_correlation = []
  #
  #  for n in 0...f_size do
  #    g_offset  = n - g_size_div_2
  #    
  #    if g_offset < 0
  #      f_window = (0...(g_size + g_offset)).entries
  #      g_window = ((g_size - f_window.count)...g_size).entries
  #    elsif g_offset < f_g_diff
  #      f_window = (g_offset...(g_size + g_offset)).entries
  #      g_window = (0...g_size).entries
  #    else
  #      f_window = (g_offset...f_size).entries
  #      g_window = (0...f_window.count).entries
  #    end
  #    
  #    binding.pry
  #    #puts "f window: #{f_window}"
  #    #puts "g window: #{g_window}"
  #    
  #    sample = 0.0
  #    for i in 0...f_window.count do
  #      i_f = f_window[i]
  #      i_g = g_window[i]
  #      sample += (f[i_f] * g[i_g])
  #    end
  #    
  #    binding.pry
  #    
  #    cross_correlation << sample
  #  end
  #  
  #  return cross_correlation
  #end
end

end
