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
class Pitch
  include Comparable
  attr_reader :octave, :semitone, :cent, :cents_per_octave

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :octave, :semitone, :cent ]  
  
  # default values for optional hashed arguments
  DEFAULT_OPTIONS = { :octave => 0, :semitone => 0, :cent => 0 }
  
  #The default number of semitones per octave is 12, corresponding to 
  # the twelve-tone equal temperment tuning system.
  SEMITONES_PER_OCTAVE = 12

  #The default number of cents per semitone is 100 (hence the name cent,
  # as in percent).
  CENTS_PER_SEMITONE = 100

  # A new instance of Pitch.
  # @param [Hash] opts Optional arguments. Valid keys are :octave, 
  #                    :semitone, :cent, :total_cent, and :ratio.
  #                    When :total_cent is set, it will override all 
  #                    other arguments.
  #                    When :ratio is set, it will override all other
  #                    arguments except :total_cent.
  #                    Otherwise, when :octave, :semitone, and :cent 
  #                    are set, each will override the default of zero.
  # @raise [ArgumentError] if any of :octave, :semitone, or :cent is
  #                        not a Fixnum.
  def initialize opts={}
    opts = DEFAULT_OPTIONS.merge opts

    @octave = opts[:octave]
    @semitone = opts[:semitone]
    @cent = opts[:cent]
    @cents_per_octave = CENTS_PER_SEMITONE * SEMITONES_PER_OCTAVE
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
  
  private
  
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
end
end
