module Music
module Transcription

# Connect one note pitch to the target pitch of the next note, via slur, legato, etc.
#
# @!attribute [rw] target_pitch
#   @return [Pitch] The pitch of the note which is being connected to.
#
class Link
  def clone
    Marshal.load(Marshal.dump(self))
  end

  class Tie < Link
    def initialize; end
    
    def ==(other)
      self.class == other.class
    end
  end
  
  class TargetedLink < Link
    attr_accessor :target_pitch
    
    def initialize target_pitch
      @target_pitch = target_pitch
    end
    
    def ==(other)
      self.class == other.class && @target_pitch == other.target_pitch
    end
  end
  
  class Glissando < TargetedLink; end
  class Portamento < TargetedLink; end
  class Slur < TargetedLink; end
  class Legato < TargetedLink; end
end

end
end
