module Music
module Transcription

class Tempo
  attr_reader :value
  def initialize value
    raise NonPositiveError, "Given tempo value #{value} is not positive" if value <= 0
    @value = value
  end
  
  def ==(other)
    self.class == other.class && self.value == other.value
  end
  
  [ :qnpm, :bpm, :npm, :nps ].each do |sym|
    klass = Class.new(Tempo) do
      def to_s
        "#{@value}#{self.class::PRINT_SYM}"
      end
    end
    klass.const_set(:PRINT_SYM,sym)
    Tempo.const_set(sym.upcase,klass)
  end
end

end
end