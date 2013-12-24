module Music
module Transcription

# Describes how to transition from one value to another.
class Transition
  attr_reader :duration
  
  def initialize duration
    @duration = duration
  end
  
  def ==(other)
    @duration == other.duration
  end

  class Immediate < Transition
    def initialize
      super(0)
    end
    
    def clone
      Immediate.new
    end
  end
  
  class Linear < Transition
    def initialize duration
      super(duration)
    end
    
    def clone
      Linear.new @duration
    end
  end
  
  class Sigmoid < Transition
    attr_reader :abruptness
    def initialize duration, abruptness = 0.5
      @abruptness = abruptness
      super(duration)
    end
    
    def clone
      Sigmoid.new @duration, @abruptness
    end
    
    def == other
      @abruptness == other.abruptness &&
      @duration == other.duration
    end
  end
end

end
end
