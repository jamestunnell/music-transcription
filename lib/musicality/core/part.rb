module Musicality

# Abstraction of a musical part. Contains notes, note sequences, and dynamics
#
# @author James Tunnell
# 
# @!attribute [rw] notes
#   @return [Hash] Maps notes by note offset.
#
# @!attribute [rw] note_sequences
#   @return [Hash] Maps note sequences by note offset.
#
# @!attribute [rw] dynamics
#   @return [Hash] Maps dynamics by note offset.
#
# @!attribute [rw] instrument
#   @return [Instrument] The instrument to be used in playing the part.
class Part

  attr_reader :notes, :note_sequences, :dynamics, :instrument
  
  # A new instance of Part.
  # @param [Hash] options Optional arguments. Valid keys are :notes, 
  #               :note_sequences, :dynamics, and :instrument
  def initialize options={}
    opts = {
      :notes => {},
      :note_sequences => {},
      :dynamics => {},
      :instrument => Instrument.new
    }.merge options
	  
    self.notes = opts[:notes]
    self.note_sequences = opts[:note_sequences]	
    self.dynamics = opts[:dynamics]
    self.instrument = opts[:instrument]
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

  # Set the part note sequences.
  # @param [Hash] note_sequences The note sequences, mapped to offsets (in note duration).
  # @raise [ArgumentError] if note_sequences is not a Hash.
  # @raise [ArgumentError] if note_sequences contain a non-NoteSequence object.
  def note_sequences= note_sequences
    raise ArgumentError, "note_sequences is not a Hash" if !note_sequences.is_a?(Hash)
    
    note_sequences.values.each do |note_group|
      raise ArgumentError, "note_sequences contain a non-NoteSequence #{note_group}" if !note_group.is_a?(NoteSequence)
    end
        
  	@note_sequences = note_sequences
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

  # Set the part instrument.
  # @param [Instrument] instrument The instrument to be used in playing the part.
  # @raise [ArgumentError] if instrument is not an Instrument.
  def instrument= instrument
    raise ArgumentError, "instrument is not a Hash" if !instrument.is_a?(Instrument)
  	@instrument = instrument
  end

end

end
