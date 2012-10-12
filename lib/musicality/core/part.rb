module Musicality

# Abstraction of a musical part. Contains notes, note groups, and dynamics
#
# @author James Tunnell
# 
# @!attribute [rw] notes
#   @return [Hash] Maps notes to offsets (in note duration).
#
# @!attribute [rw] note_groups
#   @return [Hash] Maps note groups to offsets (in note duration).
#
# @!attribute [rw] dynamics
#   @return [Hash] Maps dynamics to offsets (in note duration).
#
class Part

  attr_reader :notes, :note_groups, :dynamics
  
  # A new instance of Part.
  # @param [Hash] options Optional arguments. Valid keys are :notes, 
  #               :note_groups, :dynamics
  def initialize options={}
    opts = {
      :notes => {},
      :note_groups => {},
      :dynamics => {},
    }.merge options
	  
    self.notes = opts[:notes]
    self.note_groups = opts[:note_groups]	
    self.dynamics = opts[:dynamics]
  end
  
  # Set the part notes.
  # @param [Hash] notes The notes, mapped to offsets (in note duration).
  # @raise [ArgumentError] if notes is not a Hash.
  # @raise [ArgumentError] if notes contain a non-Note object.
  def notes= notes
    raise ArgumentError, "notes is not a Hash" if !notes.is_a?(Hash)
    
    notes.values.each do |note|
      raise ArgumentError, "notes contain a non-Note #{note}" if !note.is_a?(Note)
    end
    
    @notes = notes
  end

  # Set the part note groups.
  # @param [Hash] note_groups The note groups, mapped to offsets (in note duration).
  # @raise [ArgumentError] if note_groups is not a Hash.
  # @raise [ArgumentError] if note_groups contain a non-NoteGroup object.
  def note_groups= note_groups
    raise ArgumentError, "note_groups is not a Hash" if !note_groups.is_a?(Hash)
    
    note_groups.values.each do |note_group|
      raise ArgumentError, "note_groups contain a non-NoteGroup #{note_group}" if !note_group.is_a?(NoteGroup)
    end
        
  	@note_groups = note_groups
  end

  # Set the part dynamics.
  # @param [Hash] dynamics The dynamics, mapped to offsets (in note duration).
  # @raise [ArgumentError] if dynamics is not a Hash.
  # @raise [ArgumentError] if dynamics contain a non-Dynamic object.
  def dynamics= dynamics
    raise ArgumentError, "dynamics is not a Hash" if !dynamics.is_a?(Hash)
  	
    dynamics.values.each do |dynamic|
      raise ArgumentError, "dynamics contain a non-Dynamic #{dynamic}" if !dynamic.is_a?(Dynamic)
    end
      	
  	@dynamics = dynamics
  end

end

end
