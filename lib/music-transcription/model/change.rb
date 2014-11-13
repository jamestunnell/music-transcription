module Music
module Transcription

class Change
  attr_reader :value, :duration
  
  def initialize value, duration
    @value = value
    @duration = duration
  end
  
  def ==(other)
    self.class == other.class &&
    self.value == other.value &&
    self.duration == other.duration
  end

  class Immediate < Change
    def initialize value
      super(value,0)
    end
    
    def clone
      Immediate.new(@value)
    end
    
    def resize newdur
      self.clone
    end
  end
  
  class Gradual < Change
    def initialize value, transition_dur
      if transition_dur <= 0
        raise NonPositiveError, "transition duration #{transition_dur} must be positive"
      end
      super(value, transition_dur)
    end
    
    def clone
      Gradual.new(@value,@duration)
    end
    
    def resize newdur
      Gradual.new(@value,newdur)
    end
  end
  
  class Partial < Change
    attr_reader :elapsed, :stop
    
    def initialize value, total_dur, elapsed, stop
      if elapsed < 0
        raise NegativeError, "elapsed (#{elapsed}) is < 0"
      end
      
      if stop <= 0
        raise NonPositiveError, "stop (#{stop}) is < 0"
      end

      if stop > total_dur
        raise ArgumentError, "stop (#{stop}) is > total duration (#{total_dur})"
      end
      
      if stop <= elapsed
        raise ArgumentError, "stop (#{stop}) is <= elapsed (#{elapsed})"
      end

      @elapsed = elapsed
      @stop = stop
      super(value,stop - elapsed)
    end
    
    def ==(other)
      super() &&
      @elapsed == other.elapsed &&
      @stop == other.stop
    end
  end
end

end
end