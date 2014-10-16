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
    
    def transpose diff
      self.clone.transpose! diff
    end
    
    def transpose! diff
      return self
    end
    
    def to_s; "="; end
  end
  
  class TargetedLink < Link
    attr_accessor :target_pitch, :link_char
    
    def initialize target_pitch, link_char
      @target_pitch = target_pitch
      @link_char = link_char
    end
    
    def ==(other)
      self.class == other.class && @target_pitch == other.target_pitch
    end
    
    def transpose diff
      self.clone.transpose! diff
    end
    
    def transpose! diff
      @target_pitch = @target_pitch.transpose(diff)
    end
    
    def to_s
      @link_char + @target_pitch.to_s
    end
  end
  
  class Glissando < TargetedLink
    def initialize(target_pitch); super(target_pitch,"~"); end
  end
  
  class Portamento < TargetedLink
    def initialize(target_pitch); super(target_pitch,"/"); end
  end
  
  class Slur < TargetedLink
    def initialize(target_pitch); super(target_pitch,"="); end
  end
  
  class Legato < TargetedLink
    def initialize(target_pitch); super(target_pitch,"-"); end
  end
end

end
end
