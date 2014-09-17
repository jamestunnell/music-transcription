module Music
module Transcription

class Change
  attr_accessor :value, :duration
  
  def initialize value, duration
    @value = value
    @duration = duration
    
    unless duration >= 0
      raise ArgumentError, "duration #{duration} must be >= 0"
    end
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
  end
  
  class Gradual < Change
    def initialize value, transition_duration
      super(value, transition_duration)
    end
  end
end

end
end