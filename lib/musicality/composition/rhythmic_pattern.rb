require 'spcore'

module Musicality

# Represents a rhythmic pattern, with parts that have nonspecific durations.
# Each part duration is relative to the total sum of parts. If a total duration
# is chosen, the rhythmic pattern can be converted to durations (use the
# #to_durations method).
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
    
    parts_total = SPCore::Statistics.sum(@parts).to_f
    durations = []
    @parts.each do |part|
      duration = total_duration * (part / parts_total)
      durations.push(duration)
    end
    
    return durations
  end
end
end