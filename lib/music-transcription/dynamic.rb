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
  
  [
    :Piano, :Pianissimo, :Pianississimo,
    :MezzoPiano, :MezzoForte,
    :Forte, :Fortissimo, :Fortississimo
  ].each do |name|
    Dynamic.const_set(name, Class.new(Dynamic))
  end
end

end
end
