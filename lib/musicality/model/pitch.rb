require 'musicality'

module Musicality

# Abstraction of a musical pitch. Contains values for octave, semitone, 
# and cent. These values are useful because they allow simple mapping to
# both the abstract (musical scales) and concrete (audio data).
#
# Fundamentally, pitch can be considered a ratio to some base number. 
# For music, this is a base frequency. The pitch frequency can be 
# determined by multiplying the base frequency by the pitch ratio. For 
# the standard musical scale, the base frequency of C0 is 16.35 Hz.
# 
# Octaves represent the largest means of differing two pitches. Each 
# octave added will double the ratio. At zero octaves, the ratio is 
# 1.0. At one octave, the ratio will be 2.0. Each semitone and cent 
# is an increment of less-than-power-of-two.
#
# Semitones are the primary steps between octaves. By default, the 
# number of semitones per octave is 12, corresponding to the twelve-tone equal 
# temperment tuning system. The number of semitones per octave can be 
# modified at runtime by overriding the Pitch::SEMITONES_PER_OCTAVE 
# constant.
#
# Cents are the smallest means of differing two pitches. By default, the 
# number of cents per semitone is 100 (hence the name cent, as in per-
# cent). This number can be modified at runtime by overriding the 
# Pitch::CENTS_PER_SEMITONE constant.
#
# @author James Tunnell
# 
# @!attribute [r] octave
#   @return [Fixnum] The pitch octave.
# @!attribute [r] semitone
#   @return [Fixnum] The pitch semitone.
# @!attribute [r] cent
#   @return [Fixnum] The pitch cent.
# @!attribute [r] cents_per_octave
#   @return [Fixnum] The number of cents per octave. Default is 1200 
#    				 (12 x 100). If a different scale is required, 
#                    modify CENTS_PER_SEMITONE (default 12) and/or 
#                    SEMITONES_PER_OCTAVE (default 100).
# @!attribute [r] base_freq
#   @return [Numeric] Multiplied with pitch ratio to determine the final frequency
#                   of the pitch. Defaults to DEFAULT_BASE_FREQ, but can be set 
#                   during initialization to something else using the :base_freq key.
#
class Pitch
  include Comparable
  include Hashmake::HashMakeable
  attr_reader :cents_per_octave, :base_freq, :octave, :semitone, :cent

  #The default number of semitones per octave is 12, corresponding to 
  # the twelve-tone equal temperment tuning system.
  SEMITONES_PER_OCTAVE = 12

  #The default number of cents per semitone is 100 (hence the name cent,
  # as in percent).
  CENTS_PER_SEMITONE = 100
  
  # The default base ferquency is C0
  DEFAULT_BASE_FREQ = 16.351597831287414

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :octave => arg_spec(:reqd => false, :type => Fixnum, :default => 0),
    :semitone => arg_spec(:reqd => false, :type => Fixnum, :default => 0), 
    :cent => arg_spec(:reqd => false, :type => Fixnum, :default => 0), 
    :base_freq => arg_spec(:reqd => false, :type => Numeric, :validator => ->(a){ a > 0.0 }, :default => DEFAULT_BASE_FREQ)
  }
  
  # A new instance of Pitch.
  # @param [Hash] args Hashed args. See ARG_SPECS for details.
  # @raise [ArgumentError] if any of :octave, :semitone, or :cent is
  #                        not a Fixnum.
  def initialize args={}
    @cents_per_octave = CENTS_PER_SEMITONE * SEMITONES_PER_OCTAVE
    hash_make ARG_SPECS, args
    normalize
  end

  # Set @base_freq, which is used with the pitch ratio to produce the
  # pitch frequency.
  def base_freq= base_freq
    validate_arg ARG_SPECS[:base_freq], base_freq
    @base_freq = base_freq
  end
  
  # Set @octave.
  def octave= octave
    validate_arg ARG_SPECS[:octave], octave
    @octave = octave
  end
  
  # Set semitone.
  def semitone= semitone
    validate_arg ARG_SPECS[:semitone], semitone
    @semitone = semitone
  end
  
  # Set @cent.
  def cent= cent
    validate_arg ARG_SPECS[:cent], cent
    @cent = cent
  end
  
  # Calculate the pitch frequency by multiplying the pitch ratio by @base_freq.
  def freq
    return self.ratio() * @base_freq
  end

  # Return the pitch's frequency, which is determined by multiplying the base 
  # frequency and the pitch ratio. Base frequency defaults to DEFAULT_BASE_FREQ,
  # but can be set during initialization to something else by specifying the 
  # :base_freq key.
  def freq
    return self.ratio() * @base_freq
  end
  
  # Set the pitch according to the given frequency. Uses the current base_freq 
  # to determine what the pitch ratio should be, and sets it accordingly.
  def freq= freq
    self.ratio = freq / @base_freq
  end

  # Calculate the total cent count. Converts octave and semitone count
  # to cent count before adding to existing cent count.
  # @return [Fixnum] total cent count
  def total_cent
    return (@octave * @cents_per_octave) +
            (@semitone * CENTS_PER_SEMITONE) + @cent
  end
  
  # Set the Pitch ratio according to a total number of cents.
  # @param [Fixnum] cent The total number of cents to use.
  # @raise [ArgumentError] if cent is not a Fixnum
  def total_cent= cent
    raise ArgumentError, "cent is not a Fixnum" if !cent.is_a?(Fixnum)
    @octave, @semitone, @cent = 0, 0, cent
    normalize
  end

  # Calculate the pitch ratio. Raises 2 to the power of the total cent 
  # count divided by cents-per-octave.
  # @return [Float] ratio
  def ratio
    2.0**(self.total_cent.to_f / @cents_per_octave)
  end

  # Represent the Pitch ratio according to a ratio.
  # @param [Numeric] ratio The ratio to represent.
  # @raise [RangeError] if ratio is less than or equal to 0.0
  def ratio= ratio
    raise RangeError, "ratio #{ratio} is less than or equal to 0.0" if ratio <= 0.0
    
    x = Math.log2 ratio
    self.total_cent = (x * @cents_per_octave).round
  end

  # Round to the nearest semitone.
  def round_to_nearest_semitone
    if @cent >= (CENTS_PER_SEMITONE / 2)
      @semitone += 1
    end
    @cent = 0
    normalize
  end
  
  # Calculates the number of semitones which would represent the pitch's
  # octave and semitone count. Excludes cents.
  def total_semitone
    return (@octave * SEMITONES_PER_OCTAVE) + @semitone
  end
  
  # Override default hash method.
  def hash
    return self.total_cent
  end
  
  # Compare pitch equality using total cent
  def ==(other)
    self.total_cent == other.total_cent
  end
  
  # Compare pitches. A higher ratio or total cent is considered larger.
  # @param [Pitch] other The pitch object to compare.
  def <=> (other)
    self.total_cent <=> other.total_cent
  end

  # Add pitches by adding the total cent count of each.
  # @param [Pitch] other The pitch object to add. 
  def + (other)
    self.class.new :octave => (@octave + other.octave), :semitone => (@semitone + other.semitone), :cent => (@cent + other.cent)
  end

  # Add pitches by subtracting the total cent count.
  # @param [Pitch] other The pitch object to subtract.
  def - (other)
    self.class.new :octave => (@octave - other.octave), :semitone => (@semitone - other.semitone), :cent => (@cent - other.cent)
  end
  
  # Produce an identical Pitch object.
  def clone
    Pitch.new(:octave => @octave, :semitone => @semitone, :cent => @cent, :base_freq => @base_freq)
  end
  
  # Balance out the octave, semitone, and cent count. 
  def normalize
    centTotal = (@octave * @cents_per_octave) + (@semitone * CENTS_PER_SEMITONE) + @cent
    
    @octave = centTotal / @cents_per_octave
    centTotal -= @octave * @cents_per_octave
    
    @semitone = centTotal / CENTS_PER_SEMITONE
    centTotal -= @semitone * CENTS_PER_SEMITONE
    
    @cent = centTotal
    return true
  end

  # Produce a string representation of a pitch (e.g. "C2")
  def to_s
    if @cents_per_octave != 1200
      raise "Don't know how to produce a string representation since cents_per_octave is not 1200."
    end
    
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
      return Musicality::Pitch.new(:octave => octave, :semitone => semitone)
    elsif string =~ /[AaBbCcDdEeFfGg][\d]+/
      semitone = letter_to_semitone string[0]
      octave = string[1..-1].to_i
      return Musicality::Pitch.new(:octave => octave, :semitone => semitone)
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
