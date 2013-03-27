require 'hashmake'

module Musicality

# Abstraction of a musical note. Contains values for attack, sustain, seperation, and link
# to a successive note.
# The sustain, attack, and seperation will be used to form the envelope profile for the note.
#
# @author James Tunnell
#
# @!attribute [rw] pitch
#   @return [Pitch] The pitch of the note.
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
# @!attribute [rw] seperation
#   @return [Numeric] Shift the note release towards or away the beginning
#                   of the note. From 0.0 (towards end of the note) to 
#                   1.0 (towards beginning of the note).
#
# @!attribute [rw] link
#   @return [NoteLink] Shows how the current note is related to a following note.
#
class Note
  include Hashmake::HashMakeable
  attr_reader :pitch, :duration, :sustain, :attack, :seperation, :link

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :pitch => arg_spec(:type => Pitch, :reqd => true),
    :duration => arg_spec(:type => Numeric, :reqd => true, :validator => ->(a){ a > 0 } ),
    :sustain => arg_spec(:type => Numeric, :reqd => false, :validator => ->(a){ a.between?(0.0,1.0)}, :default => 0.5),
    :attack => arg_spec(:type => Numeric, :reqd => false, :validator => ->(a){ a.between?(0.0,1.0)}, :default => 0.5),
    :seperation => arg_spec(:type => Numeric, :reqd => false, :validator => ->(a){ a.between?(0.0,1.0)}, :default => 0.5),
    :link => arg_spec(:type => NoteLink, :reqd => false, :default => ->(){ NoteLink.new } ),
  }
  
  # A new instance of Note.
  # @param [Hash] args Hashed arguments. See Note::ARG_SPECS for details.
  def initialize args={}
    hash_make ARG_SPECS, args
  end

  # Return true if the @link relationship is not NONE.
  def linked?
    @link.relationship != NoteLink::RELATIONSHIP_NONE
  end
  
  # Compare the equality of another Note object.
  def ==(other)
    return (@pitch == other.pitch) &&
    (@duration == other.duration) &&
    (@sustain == other.sustain) &&
    (@attack == other.attack) &&
    (@seperation == other.seperation) &&
    (@link == other.link)
  end

  # Set the note duration.
  # @param [Numeric] duration The duration to use.
  # @raise [ArgumentError] if duration is not greater than 0.
  def duration= duration
    validate_arg ARG_SPECS[:duration], duration
    @duration = duration
  end
  
  # Set the note pitch.
  # @param [Pitch] pitch The pitch to use.
  # @raise [ArgumentError] if pitch is not a Pitch.
  def pitch= pitch
    validate_arg ARG_SPECS[:pitch], pitch
    @pitch = pitch
  end
  
  # Set the note sustain.
  # @param [Numeric] sustain The sustain of the note.
  # @raise [ArgumentError] if sustain is not a Numeric.
  # @raise [RangeError] if sustain is outside the range 0.0..1.0.
  def sustain= sustain
    validate_arg ARG_SPECS[:sustain], sustain
    @sustain = sustain
  end

  # Set the note attack.
  # @param [Numeric] attack The attack of the note.
  # @raise [ArgumentError] if attack is not a Numeric.
  # @raise [RangeError] if attack is outside the range 0.0..1.0.
  def attack= attack
    validate_arg ARG_SPECS[:attack], attack
    @attack = attack
  end

  # Set the note seperation.
  # @param [Numeric] seperation The seperation of the note.
  # @raise [ArgumentError] if seperation is not a Numeric.
  # @raise [RangeError] if seperation is outside the range 0.0..1.0.
  def seperation= seperation
    validate_arg ARG_SPECS[:seperation], seperation
    @seperation = seperation
  end

  # Setup the relationship to a following note.
  # @param [NoteLink] link The NoteLink object to assign.
  def link= link
    validate_arg ARG_SPECS[:link], link
    @link = link
  end
  
  # Produce an identical Note object.
  def clone
    Note.new(:pitch => @pitch, :duration => @duration, :sustain => @sustain, :attack => @attack, :seperation => @seperation, :link => @link.clone )
  end
end

end
