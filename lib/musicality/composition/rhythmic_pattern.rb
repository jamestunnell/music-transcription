require 'spcore'

module Musicality

# Represents a rhythmic pattern, with parts that have nonspecific durations.
# Each part duration is relative to the total sum of parts. Negative values 
# indicate a part where no notes will be played (rest).
# 
# The rhythmic pattern can be converted to fractions or durations.
#
# @author James Tunnell
class RhythmicPattern
  attr_reader :parts
  
  def initialize parts
    raise ArgumentError, "parts is empty" if parts.empty?
    @parts = parts
  end
  
  def to_durations total_duration
    if total_duration <= 0
      raise ArgumentError
    end
    
    to_fractions.map {|fraction| total_duration * fraction }
  end

  def to_fractions
    @parts.map {|part| Rational(part,total) }
  end

  # Compute sum of the parts' absolute values.
  def total
    SPCore::Statistics.sum(@parts.map {|part| part.abs })
  end

  def +(other)
    RhythmicPattern.new(
      to_fractions.map {|fraction| fraction * other.total} + 
        other.to_fractions.map {|fraction| fraction * total }
    )
  end
end
end