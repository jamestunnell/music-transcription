module Music
module Transcription

# Defines a note accent (stacatto, tenuto, etc.)
#
# @author James Tunnell
#
class Accent
  def ==(other)
    self.class == other.class
  end
  
  def clone
    self.class.new
  end
  
  class Stacatto < Accent
    def to_s
      return "."
    end
  end
  
  class Stacattissimo < Accent
    def to_s
      return "'"
    end
  end
  
  class Marcato < Accent
    def to_s
      return ">"
    end
  end

  class Martellato < Accent
    def to_s
      return "^"
    end
  end

  class Tenuto < Accent
    def to_s
      return "_"
    end
  end
end

end
end
