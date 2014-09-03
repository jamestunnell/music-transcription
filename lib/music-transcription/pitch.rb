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

  # A new instance of Pitch.
  # @raise [NonPositiveFrequencyError] if base_freq is not > 0.
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
  
  # Set the pitch according to the given frequency. Uses the current base_freq 
  # to determine what the pitch ratio should be, and sets it accordingly.
  def freq= freq
    self.ratio = freq / BASE_FREQ
  end

  # Calculate the total semitone count. Converts octave to semitone count
  # before adding to existing semitone count.
  # @return [Fixnum] total semitone count
  def total_semitone
    return (@octave * SEMITONES_PER_OCTAVE) + @semitone
  end
  
  # Set the Pitch ratio according to a total number of semitones.
  # @param [Fixnum] semitone The total number of semitones to use.
  # @raise [ArgumentError] if semitone is not an Integer
  def total_semitone= semitone
    raise ArgumentError, "semitone is not a Integer" if !semitone.is_a?(Integer)
    @octave, @semitone = 0, semitone
    normalize!
  end

  # Calculate the pitch ratio. Raises 2 to the power of the total semitone
  # count divided by semitones-per-octave.
  # @return [Float] ratio
  def ratio
    2.0**(self.total_semitone.to_f / SEMITONES_PER_OCTAVE)
  end

  # Represent the Pitch ratio according to a ratio.
  # @param [Numeric] ratio The ratio to represent.
  # @raise [RangeError] if ratio is less than or equal to 0.0
  def ratio= ratio
    raise RangeError, "ratio #{ratio} is less than or equal to 0.0" if ratio <= 0.0
    
    x = Math.log2 ratio
    self.total_semitone = (x * SEMITONES_PER_OCTAVE).round
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
    self.total_semitone == other.total_semitone
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
    self.class.new(
      octave: (@octave + other.octave),
      semitone: (@semitone + other.semitone)
    )
  end

  # Add pitches by subtracting the total semitone count.
  # @param [Pitch] other The pitch object to subtract.
  def - (other)
    self.class.new(
      octave: (@octave - other.octave),
      semitone: (@semitone - other.semitone),
    )
  end
  
  # Produce an identical Pitch object.
  def clone
    Marshal.load(Marshal.dump(self))  # is this cheating?
  end
  
  # Balance out the octave and semitone count. 
  def normalize!
    semitoneTotal = (@octave * SEMITONES_PER_OCTAVE) + @semitone
    
    @octave = semitoneTotal / SEMITONES_PER_OCTAVE
    semitoneTotal -= @octave * SEMITONES_PER_OCTAVE
    
    @semitone = semitoneTotal
    return self
  end

  # Produce a string representation of a pitch (e.g. "C2")
  def to_s
    semitone_str = case @semitone
    when 0 then "C"
    when 1 then "Db"
    when 2 then "D"
    when 3 then "Eb"
    when 4 then "E"
    when 5 then "F"
    when 6 then "Gb"
    when 7 then "G"
    when 8 then "Ab"
    when 9 then "A"
    when 10 then "Bb"
    when 11 then "B"
    end
    
    return semitone_str + @octave.to_s
  end
  
  def self.make_from_freq(freq)
    pitch = Pitch.new()
    pitch.ratio = freq / BASE_FREQ
    return pitch
  end
  
  def self.make_from_semitone semitones
    if semitones.is_a?(Integer)
      return Pitch.new(semitone: semitones)
    else
      raise ArgumentError, "Cannot make Pitch from #{semitones}"
    end
  end
end

end
end

class String
  # Create a Pitch object from a string (e.g. "C2"). String can contain a letter (A-G),
  # to indicate the semitone, followed by an optional sharp/flat (#/b) and then the
  # octave number (non-negative integer).
  def to_pitch
    string = self
    if string =~ /[AaBbCcDdEeFfGg][#b][\d]+/
      semitone = letter_to_semitone string[0]
      semitone = case string[1]
      when "#" then semitone + 1
      when "b" then semitone - 1
      else raise ArgumentError, "unexpected symbol found"
      end
      octave = string[2..-1].to_i
      return Music::Transcription::Pitch.new(:octave => octave, :semitone => semitone)
    elsif string =~ /[AaBbCcDdEeFfGg][\d]+/
      semitone = letter_to_semitone string[0]
      octave = string[1..-1].to_i
      return Music::Transcription::Pitch.new(:octave => octave, :semitone => semitone)
    else
      raise ArgumentError, "string #{string} cannot be converted to a pitch"
    end    
  end

  private
  
  def letter_to_semitone letter
    semitone = case letter
    when /[Cc]/ then 0
    when /[Dd]/ then 2
    when /[Ee]/ then 4
    when /[Ff]/ then 5
    when /[Gg]/ then 7
    when /[Aa]/ then 9
    when /[Bb]/ then 11
    else raise ArgumentError, "invalid letter \"#{letter}\" given"
    end
    
    return semitone
  end

end
