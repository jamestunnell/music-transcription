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
  end
  
  class Gradual < Change
    def initialize value, transition_dur
      if transition_dur <= 0
        raise NonPositiveError, "transition duration #{transition_dur} must be positive"
      end
      super(value, transition_dur)
    end
  end
end

end
end