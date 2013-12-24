module Music
module Transcription

# Score, containing parts and a program.
#
# @author James Tunnell
#
# @!attribute [rw] parts
#   @return [Array] Score parts.
# 
# @!attribute [rw] program
#   @return [Array] Score program.
#
class Score
  attr_reader :parts, :program
  
  def initialize parts: {}, program: Program.new
    @parts = parts
    @program = program
  end
    
  # Find the start of a score. The start will be at then start of whichever part begins
  # first, or 0 if no parts have been added.
  def start
    sos = 0.0
    
    @parts.each do |id,part|
      sop = part.start
      sos = sop if sop > sos
    end
    
    return sos
  end
  
  # Find the end of a score. The end will be at then end of whichever part ends 
  # last, or 0 if no parts have been added.
  def end
    eos = 0.0
    
    @parts.each do |id,part|
      eop = part.end
      eos = eop if eop > eos
    end
    
    return eos
  end
end

# Score where time is based on absolute time in seconds
class TimeScore < Score
  attr_reader :program, :parts

  def clone
    TimeScore.new @parts, @programs
  end
  
  def ==(other)
    return (@program == other.program) &&
    (@parts == other.parts)
  end
end

# Score where time is based on notes and tempo.
class TempoScore < Score
  attr_reader :tempo_profile, :program, :parts

  def initialize tempo_profile, parts: {}, program: Program.new
    @tempo_profile = tempo_profile
    raise ValueNotPositiveError unless @tempo_profile.values_positive?
    super(parts: parts, program: program)
  end
  
  def clone
    TempoScore.new @tempo_profile.clone, @parts.clone, @program.clone
  end
  
  def ==(other)
    return (@tempo_profile == other.tempo_profile) &&
    (@program == other.program) &&
    (@parts == other.parts)
  end
end

end
end
