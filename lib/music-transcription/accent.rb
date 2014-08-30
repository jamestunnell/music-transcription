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
  
  { :Staccato => ".",
    :Staccatissimo => "'",
    :Marcato => ">",
    :Martellato => "^",
    :Tenuto => "_",
    :Forte => "f",
    :Fortissimo => "ff",
    :Fortississimo => "fff"
  }.each do |name,print_str|
    klass = Class.new(Accent) do
      def to_s
        print_str
      end
    end
    Accent.const_set(name.to_sym, klass)
  end
end

end
end
