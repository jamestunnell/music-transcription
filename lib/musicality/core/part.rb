module Musicality

# Abstraction of a musical part. Contains notes, note sequences, and dynamics
#
# @author James Tunnell
# 
# @!attribute [rw] notes
#   @return [Array] The notes to be played.
#
# @!attribute [rw] note_sequences
#   @return [Array] The note sequences to be played.
#
# @!attribute [rw] dynamics
#   @return [Array] The dynamics which control part loudness.
#
# @!attribute [rw] instrument
#   @return [Instrument] The instrument to be used in playing the part.
#
class Part

  attr_reader :notes, :note_sequences, :dynamics, :instrument
  
  # A new instance of Part.
  # @param [Hash] options Optional arguments. Valid keys are :notes, 
  #                       :note_sequences, :dynamics, and :instrument
  def initialize options={}
    opts = {
      :notes => [],
      :note_sequences => [],
      :dynamics => [],
      :instrument => Instrument.new( :class => SquareWave )
    }.merge options
	  
    self.notes = opts[:notes]
    self.note_sequences = opts[:note_sequences]	
    self.dynamics = opts[:dynamics]
    self.instrument = opts[:instrument]
  end
  
  # Set the part notes.
  # @param [Array] notes Contains notes to be played.
  # @raise [ArgumentError] if notes is not an Array.
  # @raise [ArgumentError] if notes contain a non-Note objects.
  def notes= notes
    raise ArgumentError, "notes is not an Array" if !notes.is_a?(Array)
    
    notes.each do |note|
      raise ArgumentError, "notes contain a non-Note" if !note.is_a?(Note)
    end
    
    @notes = notes
  end

  # Set the part note sequences.
  # @param [Array] note_sequences Contains note sequences to be played.
  # @raise [ArgumentError] if note_sequences is not an Array.
  # @raise [ArgumentError] if note_sequences contain a non-NoteSequence objects.
  def note_sequences= note_sequences
    raise ArgumentError, "note_seqeuences is not an Array" if !note_sequences.is_a?(Array)
    
    note_sequences.each do |note_seqeuence|
      raise ArgumentError, "note_seqeuences contain a non-NoteSequence" if !note_seqeuence.is_a?(NoteSequence)
    end
    
  	@note_sequences = note_sequences
  end

  # Set the part dynamics.
  # @param [Array] dynamics The part dynamics.
  # @raise [ArgumentError] if dynamics is not an Array.
  # @raise [ArgumentError] if dynamics contain a non-Dynamic object.
  def dynamics= dynamics
    raise ArgumentError, "dynamics is not an Array" if !dynamics.is_a?(Array)
  	
    dynamics.each do |dynamic|
      raise ArgumentError, "dynamics contain a non-Dynamic #{dynamic}" if !dynamic.is_a?(Dynamic)
    end
      	
  	@dynamics = dynamics
  end

  # Set the part instrument.
  # @param [Instrument] instrument The instrument to be used in playing the part.
  # @raise [ArgumentError] if instrument is not an Instrument.
  def instrument= instrument
    raise ArgumentError, "instrument is not an Instrument" if !instrument.is_a?(Instrument)
  	@instrument = instrument
  end

  def find_end
    eop = 0.0
    @notes.each do |note|
      eon = note.offset + note.duration
      eop = eon if eon > eop
    end
    
    @note_sequences.each do |sequence|
      eos = sequence.offset + sequence.duration
      eop = eos if eos > eop
    end

    return eop
  end

end

end
