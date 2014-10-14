module Music
module Transcription

class Change
  class Immediate < Change
    def pack
      [ @value ]
    end
  end
  
  class Gradual < Change
    def pack
      [ @value, @duration ]
    end
  end

  def self.unpack packing
    case packing.size
    when 1 then Immediate.new(*packing)
    when 2 then Gradual.new(*packing)
    else raise ArgumentError, "bad array size"
    end
  end
end

end
end