module Music
module Transcription

# Defines a relationship (tie, slur, legato, etc.) to a note with a certain pitch.
#
# @author James Tunnell
#
# @!attribute [rw] target_pitch
#   @return [Pitch] The pitch of the note which is being connected to.
#
class Link
  attr_accessor :target_pitch
  
  def initialize target_pitch
    @target_pitch = target_pitch
  end

  def ==(other)
    self.class == other.class && self.target_pitch == other.target_pitch
  end
  
  def clone
    self.class.new @target_pitch.clone
  end
  
  def to_s
    return @target_pitch
  end
  
  class Slur < Link
    def initialize target_pitch
      super(target_pitch)
    end
    
    def to_s
      return "=" + super()
    end
  end
  
  class Legato < Link
    def initialize target_pitch
      super(target_pitch)
    end  
  
    def to_s
      return "-" + super()
    end
  end
  
  class Glissando < Link
    def initialize target_pitch
      super(target_pitch)
    end
    
    def to_s
      return "~" + super()
    end
  end
  
  class Portamento < Link
    def initialize target_pitch
      super(target_pitch)
    end
    
    def to_s
      return "/" + super()
    end
  end
end

end
end
