require 'hashmake'

module Musicality

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
# @!attribute [rw] intervals
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
  include Hashmake::HashMakeable
  attr_reader :duration, :intervals, :sustain, :attack, :separation

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :duration => arg_spec(:type => Numeric, :reqd => true, :validator => ->(a){ a > 0 } ),
    :intervals => arg_spec_array(:type => Interval, :reqd => false),
    :sustain => arg_spec(:type => Numeric, :reqd => false, :validator => ->(a){ a.between?(0.0,1.0)}, :default => 0.5),
    :attack => arg_spec(:type => Numeric, :reqd => false, :validator => ->(a){ a.between?(0.0,1.0)}, :default => 0.5),
    :separation => arg_spec(:type => Numeric, :reqd => false, :validator => ->(a){ a.between?(0.0,1.0)}, :default => 0.5),
  }
  
  # A new instance of Note.
  # @param [Hash] args Hashed arguments. See Note::ARG_SPECS for details.
  def initialize args={}
    hash_make ARG_SPECS, args
  end
  
  # Compare the equality of another Note object.
  def == other
    return (@duration == other.duration) &&
    (@intervals == other.intervals) &&
    (@sustain == other.sustain) &&
    (@attack == other.attack) &&
    (@separation == other.separation)
  end

  # Set the note duration.
  # @param [Numeric] duration The duration to use.
  # @raise [ArgumentError] if duration is not greater than 0.
  def duration= duration
    validate_arg ARG_SPECS[:duration], duration
    @duration = duration
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

  # Set the note separation.
  # @param [Numeric] separation The separation of the note.
  # @raise [ArgumentError] if separation is not a Numeric.
  # @raise [RangeError] if separation is outside the range 0.0..1.0.
  def separation= separation
    validate_arg ARG_SPECS[:separation], separation
    @separation = separation
  end
  
  # Produce an identical Note object.
  def clone
    Note.new(:duration => @duration, :intervals => @intervals.clone, :sustain => @sustain, :attack => @attack, :separation => @separation)
  end
  
  # Remove any duplicate intervals (occuring on the same pitch), removing
  # all but the last occurance. Remove any duplicate links (links to the
  # same interval), removing all but the last occurance.
  def remove_duplicates
    # in case of duplicate notes
    intervals_to_remove = Set.new
    for i in (0...@intervals.count).entries.reverse
      @intervals.each_index do |j|
        if j < i
          if @intervals[i].pitch == @intervals[j].pitch
            intervals_to_remove.add @intervals[j]
          end
        end
      end
    end
    @intervals.delete_if { |interval| intervals_to_remove.include? interval}
    
    # in case of duplicate links
    for i in (0...@intervals.count).entries.reverse
      @intervals.each_index do |j|
        if j < i
          if @intervals[i].linked? && @intervals[j].linked? && @intervals[i].link.target_pitch == @intervals[j].link.target_pitch
            @intervals[j].link = Link.new
          end
        end
      end
    end
  end

end

end
