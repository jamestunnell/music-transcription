module Musicality

# A group of at least two notes. The group may exist for such musical constructs
# as a chord, phrase, slur, glissando, portamento, or tuplet.
#
# @author James Tunnell
# 
# @!attribute [r] notes
#   @return [Enumerable] Two or more notes contained in an Enumerable object 
#                        (e.g. Array, Hash, etc.).
#
class Sequence < Event
  include HashMake
  attr_reader :notes

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ spec_arg(:offset, Numeric, ->(a){a.between?(Event::MIN_OFFSET, Event::MAX_OFFSET) }) ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg_array(:notes, Note) ]

  # A new instance of Sequence.
  # @param [Hash] args Hashed arguments. Required keys are :offset and :notes.
  #                    There are no optional keys.
  # @raise [ArgumentError] if notes is not an Array
  # @raise [ArgumentError] if notes contains a non-Note
  def initialize args={}
    process_args args
  end

  # Assign notes to sequence
  # @param [Array] notes A non-empty array of notes
  # @raise [ArgumentError] if notes is not an Array
  # @raise [ArgumentError] if notes contains a non-Note  
  def notes= notes
    raise ArgumentError, "notes is not an Array" if !notes.is_a?(Array)
    #raise ArgumentError, "notes is empty" if notes.empty?

    notes.each do |note|
      raise ArgumentError, "#{note} in notes is not a Note" if !note.is_a?(Note)
    end
    
    @notes = notes
  end
  
  # Caclulate sequence duration from the sum of note durations.
  def duration
    @notes.inject(0) {|duration, note| duration + note.duration }
  end
  
  # Override duration= from Event base class, because it should not be called.
  # Always throws runtime error.
  #
  # @raise [RuntimeError] if called. Duration of a note sequence is instead
  #                       derived from the sum of note durations.
  def duration= duration
    raise "Cannot set duration of a note sequence. Duration is instead derived from the sum of note durations"
  end
end

end
