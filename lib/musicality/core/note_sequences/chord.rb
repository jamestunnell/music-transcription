module Musicality

# Abstraction of a musical chord. Contains a collection of notes, all of the 
# same duration. The chord can be set to arpeggiate (i.e. a broken chord).
#
# @author James Tunnell
# 
# @!attribute [r] notes
#   @return [Enumerable] The chord notes, contained in an Enumerable object 
#                        (e.g. Array, Hash, etc.).
# @!attribute [r] arpeggiation_duration
#   @return [Rational] The desired duration of arpeggiation, which can be less 
#                      than or equal to the chord notes' durations. If 
#                      arpeggiation is not desired, set duration to zero.

class Chord < NoteSequence
  attr_reader :arpeggiation_duration
  
  # A new instance of Chord.
  # @param [Enumerable] notes Enumerable containing at least two Note objects of the same duration.
  # @param [Hash] options Optional arguments. Valid keys are :arpeggiate and :arpeggiation_duration
  def initialize notes, arpeggiation_duration = 0

    super notes
    
    duration = notes.first.duration
    notes.each do |note|
      raise ArgumentError, "duration of note #{note} in #{notes} is not the same as duration of first note." if note.duration != duration
    end

    self.arpeggiation_duration = arpeggiation_duration
  end
  
  # Set the note duration.
  # @param [Numeric] duration The duration of the note.
  # @raise [ArgumentError] if duration is not a Rational and does not respond to :to_r.
  # @raise [RangeError] if duration is less than zero.
  # @raise [RangeError] if duration is greater than chord notes.
  def arpeggiation_duration= duration
    if !duration.is_a?(Rational)
  	  raise ArgumentError, "duration is not a Rational and does not respond to :to_r" if !duration.respond_to?(:to_r)
  	  duration = duration.to_r
  	end

    raise ArgumentError, "duration is greater than chord duration" if duration > notes.first.duration
  	raise RangeError, "duration is less than 0." if duration < 0
  	@arpeggiation_duration = duration
  end
end

end
