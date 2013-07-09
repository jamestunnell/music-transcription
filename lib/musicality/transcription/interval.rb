module Musicality
# Describes a pitch (for one note) that can be linked to a pitch in another note.
#
# @author James Tunnell
#
# @!attribute [rw] pitch
#   @return [Pitch] The pitch of the note.
#
# @!attribute [rw] link
#   @return [Link] Shows how the current note is related to a following note.
#
class Interval
  include Hashmake::HashMakeable
  attr_reader :pitch, :link
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :pitch => arg_spec(:type => Pitch, :reqd => true),
    :link => arg_spec(:type => Link, :reqd => false, :default => ->(){ Link.new } ),
  }
  
  def initialize args
    hash_make args
  end
  
  # Return true if the @link relationship is not NONE.
  def linked?
    @link.relationship != Link::RELATIONSHIP_NONE
  end

  # Compare the equality of another Interval object.
  def == other
    return (@pitch == other.pitch) && (@link == other.link)
  end
  
  # Set the note pitch.
  # @param [Pitch] pitch The pitch to use.
  # @raise [ArgumentError] if pitch is not a Pitch.
  def pitch= pitch
    ARG_SPECS[:pitch].validate_value pitch
    @pitch = pitch
  end

  # Setup the relationship to a following note.
  # @param [Link] link The Link object to assign.
  def link= link
    ARG_SPECS[:link].validate_value link
    @link = link
  end

  # Produce an identical Note object.
  def clone
    Interval.new(:pitch => @pitch, :link => @link.clone)
  end
end

def interval pitch, link = Link.new
  Interval.new(:pitch => pitch, :link => link)
end

end