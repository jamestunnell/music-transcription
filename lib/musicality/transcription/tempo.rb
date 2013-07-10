module Musicality
# Represent the musical tempo, with beats ber minute and beat duration.
class Tempo
  include Comparable
  include Hashmake::HashMakeable
  
  attr_reader :beats_per_minute, :beat_duration
  
  ARG_SPECS = {
    :beats_per_minute => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){a > 0} ),
    :beat_duration => arg_spec(:reqd => false, :type => Numeric, :validator => ->(a){a > 0}, :default =>  Rational(1,4))
  }
  
  def initialize args
    hash_make args
  end
  
  def notes_per_second
    (@beats_per_minute * @beat_duration) / 60.0
  end
  
  def between? a, b
    notes_per_second.between? a, b
  end
  
  def <=>(other)
    if other.is_a? Tempo
      notes_per_second <=> other.notes_per_second
    else
      notes_per_second <=> other
    end
  end
end

module_function

def tempo beats_per_minute, beat_duration = Tempo::ARG_SPECS[:beat_duration].default
  Tempo.new(:beats_per_minute => beats_per_minute, :beat_duration => beat_duration)
end

end
