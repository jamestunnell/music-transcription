module Music
module Transcription

require 'set'

class Note
  include Validatable
  
  attr_reader :pitches, :links
  attr_accessor :articulation, :duration

  DEFAULT_ARTICULATION = Articulations::NORMAL
  
  def initialize duration, pitches = [], links: {}, articulation: DEFAULT_ARTICULATION
    self.duration = duration
    @pitches = Set.new(pitches).sort
    @links = links
    @duration = duration
    @articulation = articulation
    
    @check_methods = [ :ensure_positive_duration ]
  end
  
  def ensure_positive_duration
    unless @duration > 0
      raise NonPositiveError, "duration #{@duration} is not positive"
    end
  end
  
  def == other
    return (@duration == other.duration) &&
    (self.pitches == other.pitches) &&
    (@links.to_a.sort == other.links.to_a.sort) &&
    (@articulation == other.articulation)
  end
  
  def clone
    Marshal.load(Marshal.dump(self))
  end

  def transpose diff
    self.clone.transpose! diff
  end
  
  def transpose! diff
    unless diff.is_a?(Pitch)
      diff = Pitch.make_from_semitone(diff)
    end
    
    @pitches = @pitches.map {|pitch| pitch + diff}
    new_links = {}
    @links.each_pair do |k,v|
      v.target_pitch += diff
      new_links[k + diff] = v
    end
    @links = new_links
    return self
  end
  
  def stretch ratio
    self.clone.stretch! ratio
  end
  
  def stretch! ratio
    @duration *= ratio
    return self
  end

  def self.add_note_method(name, dur)
    self.class.send(:define_method,name.to_sym) do |pitches = [], articulation: DEFAULT_ARTICULATION, links: {}|
      Note.new(dur, pitches, articulation: articulation, links: links)
    end
  end
  
  {
    :sixteenth => Rational(1,16),
    :dotted_SIXTEENTH => Rational(3,32),
    :eighth => Rational(1,8),
    :dotted_eighth => Rational(3,16),
    :quarter => Rational(1,4),
    :dotted_quarter => Rational(3,8),
    :half => Rational(1,2),
    :dotted_half => Rational(3,4),
    :whole => Rational(1),
  }.each do |meth_name, dur|
    add_note_method meth_name, dur
  end
end

end
end
