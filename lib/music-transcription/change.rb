module Music
module Transcription

class Change
  attr_accessor :value
  
  def initialize value
    @value = value
  end
  
  def ==(other)
    self.class == other.class && self.value == other.value
  end

  class Immediate < Change
    def initialize value
      super(value)
    end
  end
  
  class Gradual < Change
    def initialize value
      super(value)
    end
  end
end

end
end