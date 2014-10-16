module Music
module Transcription

# Abstraction of a musical pitch. Contains values for octave and semitone.
#
# Octaves represent the largest means of differing two pitches. Each 
# octave added will double the ratio. At zero octaves, the ratio is 
# 1.0. At one octave, the ratio will be 2.0. Each semitone is an increment
# of less-than-power-of-two.
#
# Semitones are the primary steps between octaves. The number of
# semitones per octave is 12.

# @author James Tunnell
# 
# @!attribute [r] octave
#   @return [Fixnum] The pitch octave.
# @!attribute [r] semitone
#   @return [Fixnum] The pitch semitone.
#
class Pitch
  include Comparable
  attr_reader :octave, :semitone

  #The default number of semitones per octave is 12, corresponding to 
  # the twelve-tone equal temperment tuning system.
  SEMITONES_PER_OCTAVE = 12

  # The base ferquency is C0
  BASE_FREQ = 16.351597831287414
  
  def initialize octave:0, semitone:0
    @octave = octave
    @semitone = semitone
    normalize!
  end

  # Return the pitch's frequency, which is determined by multiplying the base 
  # frequency and the pitch ratio. Base frequency defaults to DEFAULT_BASE_FREQ,
  # but can be set during initialization to something else by specifying the 
  # :base_freq key.
  def freq
    return self.ratio() * BASE_FREQ
  end
  
  # Calculate the total semitone count. Converts octave to semitone count
  # before adding to existing semitone count.
  # @return [Fixnum] total semitone count
  def total_semitone
    return (@octave * SEMITONES_PER_OCTAVE) + @semitone
  end
  
  # Calculate the pitch ratio. Raises 2 to the power of the total semitone
  # count divided by semitones-per-octave.
  # @return [Float] ratio
  def ratio
    2.0**(self.total_semitone.to_f / SEMITONES_PER_OCTAVE)
  end

  # Round to the nearest semitone.
  def round
    self.clone.round!
  end

  # Calculates the number of semitones which would represent the pitch's
  # octave and semitone count
  def total_semitone
    return (@octave * SEMITONES_PER_OCTAVE) + @semitone
  end
  
  # Override default hash method.
  def hash
    return self.total_semitone
  end
  
  # Compare pitch equality using total semitone
  def ==(other)
    return (self.class == other.class &&
      self.total_semitone == other.total_semitone)
  end
  
  def eql?(other)
    self == other
  end
  
  # Compare pitches. A higher ratio or total semitone is considered larger.
  # @param [Pitch] other The pitch object to compare.
  def <=> (other)
    self.total_semitone <=> other.total_semitone
  end

  # Add pitches by adding the total semitone count of each.
  # @param [Pitch] other The pitch object to add. 
  def + (other)
    if other.is_a? Integer
      return Pitch.new(octave: @octave, semitone: @semitone + other)
    else
      return Pitch.new(octave: (@octave + other.octave),
        semitone: (@semitone + other.semitone))
    end
  end

  # Add pitches by subtracting the total semitone count.
  # @param [Pitch] other The pitch object to subtract.
  def - (other)
    if other.is_a? Integer
      return Pitch.new(octave: @octave, semitone: @semitone - other)
    else
      return Pitch.new(octave: (@octave - other.octave),
        semitone: (@semitone - other.semitone))
    end
  end
  
  # Produce an identical Pitch object.
  def clone
    Marshal.load(Marshal.dump(self))  # is this cheating?
  end
  
  def to_s(sharpit = false)
    letter = case semitone
    when 0 then "C"
    when 1 then sharpit  ? "C#" : "Db"
    when 2 then "D"
    when 3 then sharpit  ? "D#" : "Eb"
    when 4 then "E"
    when 5 then "F"
    when 6 then sharpit  ? "F#" : "Gb"
    when 7 then "G"
    when 8 then sharpit  ? "G#" : "Ab"
    when 9 then "A"
    when 10 then sharpit  ? "A#" : "Bb"
    when 11 then "B"
    end
    
    return letter + octave.to_s
  end
  
  def self.from_ratio ratio
    raise NonPositiveError, "ratio #{ratio} is not > 0" unless ratio > 0
    x = Math.log2 ratio
    semitones = (x * SEMITONES_PER_OCTAVE).round
    from_semitones(semitones)
  end
  
  def self.from_freq freq
    from_ratio(freq / BASE_FREQ)
  end
  
  def self.from_semitones semitones
    Pitch.new(semitone: semitones)
  end
  
  private
  
  # Balance out the octave and semitone count. 
  def normalize!
    semitoneTotal = (@octave * SEMITONES_PER_OCTAVE) + @semitone
    
    @octave = semitoneTotal / SEMITONES_PER_OCTAVE
    semitoneTotal -= @octave * SEMITONES_PER_OCTAVE
    
    @semitone = semitoneTotal
    return self
  end
end

end
end
