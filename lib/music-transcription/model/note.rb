module Music
module Transcription

require 'set'

class Note
  include Validatable
  
  attr_reader :pitches, :links
  attr_accessor :articulation, :duration, :accented

  DEFAULT_ARTICULATION = Articulations::NORMAL
  
  @@check_methods = [ :ensure_positive_duration ]
  def initialize duration, pitches = [], articulation: DEFAULT_ARTICULATION, accented: false, links: {}
    @duration = duration
    @pitches = Set.new(pitches).sort
    @articulation = articulation
    @accented = accented
    @links = links
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
    (@articulation == other.articulation) &&
    (@accented == other.accented)
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
      v.transpose! diff
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
  
  def to_s
    d = @duration.to_r
    if d.denominator == 1
      dur_str = "#{d.numerator}"
    elsif d.numerator == 1
      dur_str = "/#{d.denominator}"
    else
      dur_str = d.to_s
    end
    
    art_str = case @articulation
    when Articulations::SLUR then "="
    when Articulations::LEGATO then "-"
    when Articulations::TENUTO then "_"
    when Articulations::PORTATO then "%"
    when Articulations::STACCATO then "."
    when Articulations::STACCATISSIMO then "'"
    else ""
    end
    
    pitch_links_str = @pitches.map do |p|
      if @links.has_key?(p)
        p.to_s + @links[p].to_s
      else
        p.to_s
      end
    end.join(",")
    
    acc_str = @accented ? "!" : ""
    return dur_str + art_str + pitch_links_str + acc_str
  end

  def self.add_note_method(name, dur)
    self.class.send(:define_method,name.to_sym) do |pitches = [], articulation: DEFAULT_ARTICULATION, links: {}, accented: false|
      Note.new(dur, pitches, articulation: articulation, links: links, accented: accented)
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