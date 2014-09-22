module Music
module Transcription

require 'set'

class Note
  include Validatable
  
  attr_reader :pitches, :links
  attr_accessor :accent, :duration

  def initialize duration, pitches = [], links: {}, accent: Accents::NONE
    self.duration = duration
    @pitches = Set.new(pitches).sort
    @links = links
    @duration = duration
    @accent = accent
    
    @check_methods = [ :ensure_positive_duration ]
  end
  
  def ensure_positive_duration
    unless @duration > 0
      raise ValueNotPositiveError, "duration #{@duration} is not positive"
    end
  end
  
  def == other
    return (@duration == other.duration) &&
    (self.pitches == other.pitches) &&
    (@links.to_a.sort == other.links.to_a.sort) &&
    (@accent == other.accent)
  end
  
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  def clear_links
    @links = {}
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
  
  class Sixteenth < Note
    def initialize pitches = [], links: {}, accent: Accents::NONE
      super(Rational(1,16),pitches,links:links,accent:accent)
    end
  end
  
  class DottedSixteenth < Note
    def initialize pitches = [], links: {}, accent: Accents::NONE
      super(Rational(3,32),pitches,links:links,accent:accent)
    end
  end
  
  class Eighth < Note
    def initialize pitches = [], links: {}, accent: Accents::NONE
      super(Rational(1,8),pitches,links:links,accent:accent)
    end
  end
  
  class DottedEighth < Note
    def initialize pitches = [], links: {}, accent: Accents::NONE
      super(Rational(3,16),pitches,links:links,accent:accent)
    end
  end
  
  class Quarter < Note
    def initialize pitches = [], links: {}, accent: Accents::NONE
      super(Rational(1,4),pitches,links:links,accent:accent)
    end
  end
  
  class DottedQuarter < Note
    def initialize pitches = [], links: {}, accent: Accents::NONE
      super(Rational(3,8),pitches,links:links,accent:accent)
    end
  end
  
  class Half < Note
    def initialize pitches = [], links: {}, accent: Accents::NONE
      super(Rational(1,2),pitches,links:links,accent:accent)
    end
  end
  
  class DottedHalf < Note
    def initialize pitches = [], links: {}, accent: Accents::NONE
      super(Rational(3,4),pitches,links:links,accent:accent)
    end
  end
    
  class Whole < Note
    def initialize pitches = [], links: {}, accent: Accents::NONE
      super(Rational(1,1),pitches,links:links,accent:accent)
    end
  end
end

end
end
