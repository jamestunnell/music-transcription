require 'hashmake'

module Musicality

# A group of notes. The group may exist for such musical constructs
# as a chord, phrase, slur, glissando, portamento, or tuplet.
#
# @author James Tunnell
# 
# @!attribute [r] notes
#   @return [Array] Array of notes.
#
class NoteSequence < Event
  include Hashmake::HashMakeable
  attr_reader :notes

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :offset => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){a.between?(Event::MIN_OFFSET, Event::MAX_OFFSET) }),
    :notes => arg_spec_array(:reqd => false, :type => Note)
  }

  # A new instance of NoteSequence.
  # @param [Hash] args Hashed arguments. Required keys are :offset and :notes.
  #                    There are no optional keys.
  # @raise [ArgumentError] if notes is not an Array
  # @raise [ArgumentError] if notes contains a non-Note
  def initialize args={}
    hash_make ARG_SPECS, args
  end

  # Assign notes to sequence
  # @param [Array] notes A non-empty array of notes
  # @raise [ArgumentError] if notes is not an Array
  # @raise [ArgumentError] if notes contains a non-Note  
  def notes= notes
    validate_arg ARG_SPECS[:notes], notes
    @notes = notes
  end
  
  # Caclulate sequence duration from the sum of note durations.
  def duration
    @notes.inject(0) {|duration, note| duration + note.duration }
  end
  
  # Override duration= from Event base class, because it should not be called.
  # Always throws runtime error.
  #
  # @raise [RuntimeError] if called. Duration of a sequence is instead
  #                       derived from the sum of note durations.
  def duration= duration
    raise "Cannot set duration of a sequence. Duration is instead derived from the sum of note durations"
  end
end

end
