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

class Chord
  attr_reader :notes, :arpeggiate, :arpeggiation_duration
  
  # A new instance of Note.
  # @param [Enumerable] notes a non-empty Enumerable containing only Note objects of the same duration.
  # @param [Hash] options Optional arguments. Valid keys are :arpeggiate and :arpeggiation_duration
  def initialize notes, options={}

    raise ArgumentError, "notes is not an Enumerable" if !notes.is_a?(Enumerable)
    raise ArgumentError, "notes is empty" if notes.empty?

    duration = nil
    notes.each do |note|
      raise ArgumentError, "#{note} in notes is not a Note" if !note.is_a?(Note)
      
      if duration.nil?
        duration = note.duration
      else
        raise ArgumentError, "length of note #{note} in #{notes} is not the same as length of first note." if note.duration != duration
      end
    end

    @notes = notes
    duration = notes.first.duration
    
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
