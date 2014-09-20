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
  
  [
    :None, :Staccato, :Staccatissimo, :Marcato, :Martellato, :Tenuto
  ].each do |name|
    Accent.const_set(name, Class.new(Accent))
  end
end

end
end
