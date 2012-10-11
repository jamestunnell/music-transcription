module Musicality

# Abstraction of a musical part. Contains notes, note groups, and loudness 
# markers.
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
  def notes= notes
    raise ArgumentError, "notes is not a Hash" if !notes.is_a?(Hash)
    @notes = notes
  end

  # Set the part note groups.
  # @param [Hash] note_groups The note groups, mapped to offsets (in note duration).
  # @raise [ArgumentError] if note_groups is not a Hash.
  def note_groups= note_groups
    raise ArgumentError, "note_groups is not a Hash" if !note_groups.is_a?(Hash)
  	@note_groups = note_groups
  end

  # Set the part dynamics.
  # @param [Hash] dynamics The dynamics, mapped to offsets (in note duration).
  # @raise [ArgumentError] if dynamics is not a Hash.
  def dynamics= dynamics
    raise ArgumentError, "dynamics is not a Hash" if !dynamics.is_a?(Hash)
  	@dynamics = dynamics
  end

end

end
