module Music
module Transcription

class Change
  attr_reader :value
  
  def initialize value
    @value = value
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