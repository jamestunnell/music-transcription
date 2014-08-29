module Music
module Transcription

# Defines a dynamic level
#
# @author James Tunnell
#
class Dynamic
  def ==(other)
    self.class == other.class
  end
  
  def clone
    self.class.new
  end
  
  class Piano < Dynamic
    def to_s
      return "p"
    end
  end
  
  class Pianissimo < Dynamic
    def to_s
      return "pp"
    end
  end
  
  class Pianississimo < Dynamic
    def to_s
      return "ppp"
    end
  end

  class MezzoPiano < Dynamic
    def to_s
      return "mp"
    end
  end

  class MezzoForte < Dynamic
    def to_s
      return "mf"
    end
  end

  class Forte < Dynamic
    def to_s
      return "f"
    end
  end
  
  class Fortissimo < Dynamic
    def to_s
      return "ff"
    end
  end
  
  class Fortississimo < Dynamic
    def to_s
      return "fff"
    end
  end
end

end
end
