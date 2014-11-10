module Music
module Transcription

class Change
  attr_accessor :value, :duration
  
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
    include Validatable

    def initialize value
      super(value,0)
    end
    
    def check_methods
      [ :ensure_zero_duration ]
    end
    
    def ensure_zero_duration
      unless @duration == 0
        raise NonZeroError, "immediate change duration #{self.duration} must be 0"
      end
    end
  end
  
  class Gradual < Change
    include Validatable
    
    def initialize value, transition_duration
      super(value, transition_duration)
    end
    
    def check_methods
      [ :ensure_nonnegative_duration ]
    end
    
    def ensure_nonnegative_duration
      if @duration < 0
        raise NegativeError, "gradual change duration #{self.duration} must be non-negative"
      end
    end
  end
end

end
end