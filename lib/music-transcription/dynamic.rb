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
  
  { :Piano => "p",
    :Pianissimo => "pp",
    :Pianississimo => "ppp",
    :MezzoPiano => "mp",
    :MezzoForte => "mf",
    :Forte => "f",
    :Fortissimo => "ff",
    :Fortississimo => "fff"
  }.each do |name,print_str|
    klass = Class.new(Dynamic) do
      def to_s
        print_str
      end
    end
    Dynamic.const_set(name.to_sym, klass)
  end
end

end
end
