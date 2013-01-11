module Musicality

class Window
  WINDOW_RECTANGLE = :windowRectangle
  WINDOW_TRIANGLE = :windowTriangle
  
  WINDOW_TYPES = [
    WINDOW_RECTANGLE,
    WINDOW_TRIANGLE
  ]
  
  attr_reader :data, :type
  
  def initialize size, window_type
    raise ArgumentError, "window_type #{window_type} is not one of WINDOW_TYPES" unless WINDOW_TYPES.include? window_type
    
    @data = []
    
    if window_type == WINDOW_RECTANGLE
      
      size.times do
        @data << 1.0
      end
      
    elsif window_type == WINDOW_TRIANGLE
      
      is_even = (size % 2 == 0)
      count = is_even ? size : (size + 1)
      
      incr = 2.0 / (count.to_f)
      val = incr
      for i in 0...(size / 2) do
        @data << val
        val += incr
      end
      
      if is_even
        val -= incr
      end
      
      for i in (size / 2)...size do
        @data << val
        val -= incr
      end
      
    end

  end

end

end
