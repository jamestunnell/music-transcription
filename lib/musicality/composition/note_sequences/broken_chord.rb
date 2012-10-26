module Musicality

# Representaion of a broken chord. Contains a collection of notes, all of the 
# same duration, which form a chord. The chord notes will be played in 
# succession (not simultaneously) and sustained, like a guitar strum.
#
# @author James Tunnell
# 
# @!attribute [r] root_note
#   @return [Enumerable] The chord notes, contained in an Enumerable object 
#                        (e.g. Array, Hash, etc.).
# @!attribute [r] strum_duration
#   @return [Rational] The duration of the strum, where each chord note is 
#                      played. Must be less than or equal to the chord  
#                      durations. Setting to zero will eliminate the effect.
#
class BrokenChord < NoteSequence
  attr_reader :strum_duration
  
  # A new instance of BrokenChord.
  # @param [Enumerable] notes Enumerable containing at least two Note objects of the same duration.
  # @param [Numeric] strum_duration The duration of the broken chord strum.
  def initialize notes, strum_duration = 0.to_r

    super notes
    
    duration = notes.first.duration
    notes.each do |note|
      raise ArgumentError, "duration of note #{note} in #{notes} is not the same as duration of first note." if note.duration != duration
    end

    self.strum_duration = strum_duration
  end
  
  # Set the note duration.
  # @param [Numeric] duration The duration of the note.
  # @raise [ArgumentError] if duration is not a Rational and does not respond to :to_r.
  # @raise [RangeError] if duration is less than zero.
  # @raise [RangeError] if duration is greater than chord notes.
  def strum_duration= duration
    if !duration.is_a?(Rational)
  	  raise ArgumentError, "duration is not a Rational and does not respond to :to_r" if !duration.respond_to?(:to_r)
  	  duration = duration.to_r
  	end

    raise ArgumentError, "duration is greater than chord duration" if duration > notes.first.duration
  	raise RangeError, "duration is less than 0." if duration < 0
  	@strum_duration = duration
  end
end

end
