module Musicality

## Use by the Seqeuencer class to determine when a note from a sequence is to be 
## played.
## 
## @author James Tunnell
#class NoteEvent < Event
#  attr_reader :note
#  attr_accessor :id
#  def initialize offset, note, id = UniqueToken.make_unique_sym(3)
#    @note = note
#    @id = id
#    super(offset, note, note.duration)
#  end
#end

## Assist in the performance of a note sequence. Based on note offset, the 
## sequencer determines if notes are past, current (being played), or future 
## (to be played).
## 
# @author James Tunnell
class Sequencer
  def initialize note_sequences
    @instruction_sequences = []
    note_sequences.each do |note_sequence|
      @instruction_sequences += make_instruction_sequences_from_note_sequence(sequence)
    end
    
    @instruction_sequences.each do |seq|
      raise "instruction sequence #{seq} has no END" unless seq.has_end?
    end

    @instructions_future = {}
    @instructions_past = {}
  end
  
  # Called as part of preparation for performance. Reset instruction lists 
  # for the given offset, determine which instructions are past playing, 
  # and which will occur in the future. Rebuild lists accordingly.
  #
  # @param [Float] start_offset The note offset where performance will begin.
  def prepare_to_perform start_offset = 0.0
    @instructions_future.clear
    @instructions_past.clear
    
    @instruction_sequences.each do |seq|
      @instructions_future[seq.id] = seq.instructions.select { |instr| instr.offset >= start_offset }
      @instructions_past[seq.id] = seq.instructions.select { |instr| instr.offset < start_offset }
    end
  end

#  # @return [Hash] The notes to either start playing (use key :to_start) or to 
#  #                stop playing (use key :to_end).
  def get_instructions_at counter
    instructions = {}
    @instructions_future.each do |seq_id, instrs|
      instructions[seq_id] = instrs.select { |instr| instr.offset <= note_counter }
      instrs.keep_if { |instr| instr.offset > note_counter }
    end

#    to_start.each do |event|
#      @note_events_current << event
#      @note_events_future.delete event
#    end
#    
#    to_end = @note_events_current.select { |event| note_counter >= (event.offset + event.duration) }
#
#    to_end.each do |event|
#      @note_events_past << event
#      @note_events_current.delete event
#    end
#    
#    return { :to_start => to_start, :to_end => to_end }
  end
#  
#  def active?
#    !@note_events_current.empty?
#  end
#end

  private
  
  def make_instruction_sequences_from_note_sequence sequence
    instr_sequences = []

    offset = sequence.offset    
    seq = nil

    for i in 0...sequence.notes.count do
      note = sequence.notes[i]

      unless seq
        seq = InstructionSequence.new(offset, note)
        instr_sequences.push seq
      end
      
      if i == (sequence.notes.count - 1)  # on the last note of sequence, ignore relationship and just end the instruction sequence
        seq.end offset + note.duration
        seq = nil
      else
        case note.relationship
        when Note::RELATIONSHIP_NONE
          seq.end offset + note.duration
          seq = nil
  #      when Note::RELATIONSHIP_TIE
  #        seq.push Instruction.new(Instruction::OFF, offset + note.duration)
        when Note::RELATIONSHIP_SLUR
          seq.add Instruction.new(Instruction::CHANGE_PITCH, offset, note)
        when Note::RELATIONSHIP_LEGATO
          seq.add Instruction.new(Instruction::CHANGE_PITCH, offset, note)
          seq.add Instruction.new(Instruction::RESTART_ATTACK, offset, note)
        #when Note::RELATIONSHIP_GLISSANDO
        #when Note::RELATIONSHIP_PORTAMENTO
        else
          raise ArgumentError, "note relationship #{note.relationship} is not valid"
        end
      end
      
      offset += note.duration      
    end
      
    return instr_sequences
  end
  
#  attr_reader :sequence, :note_events, :note_events_future, :note_events_current, :note_events_past
#  def initialize sequence
#    @sequence = sequence
#    
#    @note_events = []
#    offset = @sequence.offset
#    @sequence.notes.each_index do |i|
#      
#      note = @sequence.notes[i]
#      
#      #attack_release_time = instrument.figure_attack_release_time note
#      #offset -= attack_time
#      #note.duration += attack_time
#      #
#      #if i != last_idx
#      #  
#      #end
#      #
#      #release_time = instrument.figure_release_time note.sustain
#      #note.duration -= release_time
#      #
#      #if @note_events.any?
#      #  @note_events.last.note.duration -= attack_time
#      #  @note_events.last.duration -= attack_time
#      #end
#      
#      @note_events << NoteEvent.new(offset, note)
#      offset += note.duration
#    end
#    
#    @note_events_future = []
#    @note_events_current = []
#    @note_events_past = []
#  end

end

