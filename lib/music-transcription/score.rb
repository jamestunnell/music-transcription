module Music
module Transcription

# Score, containing parts and a program.
#
# @author James Tunnell
#
# @!attribute [rw] parts
#   @return [Hash] Score parts, mapped to part names
# 
# @!attribute [rw] program
#   @return [Program] Score program (which segments are played when)
#
# @!attribute [rw] tempo_profile
#   @return [Profile] Tempo values profile
#
class Score
  attr_reader :parts, :program, :tempo_profile
  
  def initialize parts: {}, program: Program.new, tempo_profile: Profile.new(Tempo.new(120))
    @parts = parts
    @program = program
    @tempo_profile = tempo_profile
  end

  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  def ==(other)
    return (@tempo_profile == other.tempo_profile) &&
    (@program == other.program) &&
    (@parts == other.parts)
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

end
end
