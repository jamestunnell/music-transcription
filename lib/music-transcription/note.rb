module Music
module Transcription

require 'set'

# Abstraction of a musical note. The note can contain zero or more pitches,
# with links to a pitches in a following note. The note also has an accent,
# which must be one of Note::ACCENTS.
#
# @author James Tunnell
# 
# @!attribute [rw] duration
#   @return [Numeric] The duration (in, say note length or time), greater than 0.0.
#
# @!attribute [r] pitches
#   @return [Set] The pitches that are part of the note and can link to
#                   pitches in a following note.
#
# @!attribute [r] links
#   @return [Hash] Maps pitches in the current note to pitches in the following
#                  note, by some link class, like Link::Slur.
# 
# @!attribute [rw] accent
#   @return [Accent] The accent type, which must be one of Note::ACCENTS.
#
class Note
  attr_reader :duration, :pitches, :links
  attr_accessor :accent

  # A new instance of Note.
  def initialize duration, pitches = [], links: {}, accent: nil
    self.duration = duration
    @pitches = Set.new(pitches).sort
    @links = links
    self.accent = accent
  end
  
  # Compare the equality of another Note object.
  def == other
    return (@duration == other.duration) &&
    (self.pitches == other.pitches) &&
    (@links.to_a.sort == other.links.to_a.sort) &&
    (@accent == other.accent)
  end

  # Set the note duration.
  # @param [Numeric] duration The duration to use.
  # @raise [ArgumentError] if duration is not greater than 0.
  def duration= duration
    raise ValueNotPositiveError if duration <= 0
    @duration = duration
  end
  
  # Produce an identical Note object.
  def clone
    Marshal.load(Marshal.dump(self))
  end

  def transpose_pitches_only pitch_diff
    self.clone.transpose_pitches! pitch_diff, transpose_link
  end

  def transpose_pitches_only! pitch_diff
    @pitches = @pitches.map {|pitch| pitch + pitch_diff}
    new_links = {}
    @links.each_pair do |k,v|
      new_links[k + pitch_diff] = v
    end
    @links = new_links
    return self
  end
  
  def transpose_pitches_and_links pitch_diff
    self.clone.transpose_pitches_and_links! pitch_diff
  end

  def transpose_pitches_and_links! pitch_diff
    @pitches = @pitches.map {|pitch| pitch + pitch_diff}
    new_links = {}
    @links.each_pair do |k,v|
      v.target_pitch += pitch_diff
      new_links[k + pitch_diff] = v
    end
    @links = new_links
    return self
  end
  
  def to_s
    output = @duration.to_s
    if @pitches.any?
      output += "@"
      @pitches[0...-1].each do |pitch|
        output += pitch.to_s
        if @links.has_key? pitch
          output += @links[pitch].to_s
        end
        output += ","
      end
      
      last_pitch = @pitches[-1]
      output += last_pitch.to_s
      if @links.has_key? last_pitch
        output += @links[last_pitch].to_s
      end
    end
    
    return output
  end
end

end
end
