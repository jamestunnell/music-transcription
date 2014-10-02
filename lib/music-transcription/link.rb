module Music
module Transcription

# Connect one note pitch to the target pitch of the next note, via slur, legato, etc.
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
  
  [ :Slur,
    :Legato,
    :Glissando,
    :Portamento,
  ].each do |name|
    klass = Class.new(Link) do
      def initialize target_pitch
        super(target_pitch)
      end
    end
    Link.const_set(name.to_sym, klass)
  end
end

end
end
