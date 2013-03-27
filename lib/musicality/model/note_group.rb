require 'set'

module Musicality

# Contain any number of Note Objects (including none), which
# must have identical duration.
#
# @author James Tunnell
class NoteGroup
  include Hashmake::HashMakeable
  
  # define how hashed args may be used to initialize a new instance.
  ARG_SPECS = {
    :duration => arg_spec(:type => Numeric, :reqd => true, :validator => ->(a){ a > 0 }),
    :notes => arg_spec_array(:type => Note, :reqd => false),
  }
  
  attr_reader :notes, :duration
  
  def initialize args
    validate_arg ARG_SPECS[:duration], args[:duration]
    # this litte pre-hashmake step allows note hashes to forgoe the
    # duration parameter since note group requires it
    if args.has_key? :notes
      args[:notes].each do |note|
        if note.is_a?(Hash)
          note[:duration] = args[:duration]
        end
      end
    end
    
    hash_make ARG_SPECS, args
    
    # enfore duration
    @notes.each do |note|
      note.duration = @duration
    end
    
    clear_duplicates
  end
  
  # Compare the equality of another NoteGroup object.
  def ==(other)
    return (@duration == other.duration) &&
    (@notes == other.notes)
  end
  
  # Remove any duplicate notes (notes occuring on the same pitch), remove all
  # but the last occurance. Remove any duplicate links (links to the same pitch),
  # remove all but the last occurance.
  def clear_duplicates
    # in case of duplicate notes
    notes_to_remove = Set.new
    for i in (0...@notes.count).entries.reverse
      @notes.each_index do |j|
        if j < i
          if @notes[i].pitch == @notes[j].pitch
            notes_to_remove.add @notes[j]
          end
        end
      end
    end
    @notes.delete_if { |note| notes_to_remove.include? note }
    
    # in case of duplicate links
    for i in (0...@notes.count).entries.reverse
      @notes.each_index do |j|
        if j < i
          if @notes[i].linked? && @notes[j].linked? && @notes[i].link.target_pitch == @notes[j].link.target_pitch
            @notes[j].link = NoteLink.new
          end
        end
      end
    end
  end
  
  # Assign a value for note group duration.
  # @param [Numeric] duration The duration of the note group.
  # @raise [ArgumentError] if duration is not a Numeric
  # @raise [ArgumentError] if duration is not greater than zero.
  def duration= duration
    validate_arg ARG_SPECS[:duration], duration
    @duration = duration
    
    @notes.each do |note|
      note.duration = @duration
    end
  end
  
  # Produce an identical NoteGroup object.
  def clone
    NoteGroup.new(:duration => @duration, :notes => @notes.map {|note| note.clone })
  end
end
  
end