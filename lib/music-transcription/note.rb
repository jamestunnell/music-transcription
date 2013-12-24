module Music
module Transcription

require 'set'

# Abstraction of a musical note. The note can contain multiple intervals
# (at different pitches). Each interval can also contain a link to an interval
# in a following note. Contains values for attack, sustain, and separation,
# which will be used to form the envelope profile for the note.
#
# @author James Tunnell
# 
# @!attribute [rw] duration
#   @return [Numeric] The duration (in, say note length or time), greater than 0.0.
#
# @!attribute [r] intervals
#   @return [Numeric] The intervals that define which pitches are part of the
#                     note and can link to intervals in a following note.
# 
# @!attribute [rw] attack
#   @return [Numeric] The amount of attack, from 0.0 (less) to 1.0 (more).
#                     Attack controls how quickly a note's loudness increases
#                     at the start.
#
# @!attribute [rw] sustain
#   @return [Numeric] The amount of sustain, from 0.0 (less) to 1.0 (more).
#                     Sustain controls how much the note's loudness is 
#                     sustained after the attack.
#
# @!attribute [rw] separation
#   @return [Numeric] Shift the note release towards or away the beginning
#                   of the note. From 0.0 (towards end of the note) to 
#                   1.0 (towards beginning of the note).
#
class Note
  attr_reader :duration, :sustain, :attack, :separation

  # A new instance of Note.
  def initialize duration, pitches = [], links: {}, sustain: 0.5, attack: 0.5, separation: 0.5
    self.duration = duration
    @links = links
    @pitches = Set.new(pitches)
    self.sustain = sustain
    self.attack = attack
    self.separation = separation
  end
  
  def pitches
    return @pitches.entries
  end
  
  # Compare the equality of another Note object.
  def == other
    return (@duration == other.duration) &&
    (self.pitches == other.pitches) &&
    (@links == other.links) &&
    (@sustain == other.sustain) &&
    (@attack == other.attack) &&
    (@separation == other.separation)
  end

  # Set the note duration.
  # @param [Numeric] duration The duration to use.
  # @raise [ArgumentError] if duration is not greater than 0.
  def duration= duration
    raise ValueNotPositiveError if duration <= 0
    @duration = duration
  end  
  
  # Set the note sustain.
  # @param [Numeric] sustain The sustain of the note.
  # @raise [ArgumentError] if sustain is not a Numeric.
  # @raise [RangeError] if sustain is outside the range 0.0..1.0.
  def sustain= sustain
    raise ValueOutOfRangeError unless sustain.between?(0.0,1.0)
    @sustain = sustain
  end

  # Set the note attack.
  # @param [Numeric] attack The attack of the note.
  # @raise [ArgumentError] if attack is not a Numeric.
  # @raise [RangeError] if attack is outside the range 0.0..1.0.
  def attack= attack
    raise ValueOutOfRangeError unless attack.between?(0.0,1.0)
    @attack = attack
  end

  # Set the note separation.
  # @param [Numeric] separation The separation of the note.
  # @raise [ArgumentError] if separation is not a Numeric.
  # @raise [RangeError] if separation is outside the range 0.0..1.0.
  def separation= separation
    raise ValueOutOfRangeError unless separation.between?(0.0,1.0)
    @separation = separation
  end
  
  # Produce an identical Note object.
  def clone
    Marshal.load(Marshal.dump(self))
  end
 
  ## Remove any duplicate pitches (occuring on the same pitch), removing
  ## all but the last occurance. Remove any duplicate links (links to the
  ## same interval), removing all but the last occurance.
  #def remove_duplicates
  #  # in case of duplicate notes
  #  intervals_to_remove = Set.new
  #  for i in (0...@intervals.count).entries.reverse
  #    @intervals.each_index do |j|
  #      if j < i
  #        if @intervals[i].pitch == @intervals[j].pitch
  #          intervals_to_remove.add @intervals[j]
  #        end
  #      end
  #    end
  #  end
  #  @intervals.delete_if { |interval| intervals_to_remove.include? interval}
  #  
  #  # in case of duplicate links
  #  for i in (0...@intervals.count).entries.reverse
  #    @intervals.each_index do |j|
  #      if j < i
  #        if @intervals[i].linked? && @intervals[j].linked? && @intervals[i].link.target_pitch == @intervals[j].link.target_pitch
  #          @intervals[j].link = Link.new
  #        end
  #      end
  #    end
  #  end
  #end

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
