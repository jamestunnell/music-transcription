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
      @check_methods = [ :ensure_zero_duration ]
      super(value,0)
    end
    
    def ensure_zero_duration
      unless @duration == 0
        raise ValueNotZeroError, "immediate change duration #{self.duration} must be 0"
      end
    end
  end
  
  class Gradual < Change
    include Validatable
    
    def initialize value, transition_duration
      @check_methods = [ :ensure_positive_duration ]
      super(value, transition_duration)
    end
    
    def ensure_positive_duration
      if @duration < 0
        raise ValueNotPositiveError, "gradual change duration #{self.duration} must be >= 0"
      end
    end
  end
end

end
end