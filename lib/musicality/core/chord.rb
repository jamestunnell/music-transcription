module Musicality

# Abstraction of a musical chord. Contains a collection of notes, all of the 
# same duration. The chord can be set to arpeggiate (i.e. a broken chord).
#
# @author James Tunnell
# 
# @!attribute [r] notes
#   @return [Enumerable] The chord notes, contained in an Enumerable object (e.g. Array, Hash, etc.).
# @!attribute [r] arpeggiate
#   @return [true/false] Play each chord note in succession, sustaining each note.
# @!attribute [r] arpeggiation_duration
#   @return [Rational] The desired duration of arpeggiation, which can be less than or equal to the chord notes' durations.

class Chord < NoteGroup
  attr_reader :arpeggiate, :arpeggiation_duration
  
  # A new instance of Chord.
  # @param [Enumerable] notes Enumerable containing at least two Note objects of the same duration.
  # @param [Hash] options Optional arguments. Valid keys are :arpeggiate and :arpeggiation_duration
  def initialize notes, options={}

    super notes, NOTE_GROUP_CHORD
    
    duration = notes.first.duration
    notes.each do |note|
      raise ArgumentError, "duration of note #{note} in #{notes} is not the same as duration of first note." if note.duration != duration
    end

    opts = { 
      :arpeggiate => false,
      :arpeggiation_duration => duration 
    }.merge(options)
    
    @arpeggiate = opts[:arpeggiate]
    @arpeggiation_duration = opts[:arpeggiation_duration]
    
    raise ArgumentError, "options[:arpeggiation_duration] is not a Rational" if !@arpeggiation_duration.is_a?(Rational)
    raise ArgumentError, "options[:arpeggiation_duration] #{@arpeggiation_duration} is greater than chord duration" if @arpeggiation_duration > duration
    
  end
end

end
