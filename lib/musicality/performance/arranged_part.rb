module Musicality

# Takes a composed part, derives information useful for performing, and stores it for
# performer. Converts note sequences to note instruction sequences. Finds plugins using
# plugin configs. Saves loudness profile as-is.
#
# @author James Tunnell
class ArrangedPart
  attr_reader :instruction_sequences, :loudness_profile, :instrument_plugins, :effect_plugins

  def initialize composed_part
    @loudness_profile = composed_part.loudness_profile
    @instrument_plugins = []
    @effect_plugins = []

    composed_part.instrument_plugins.each do |plugin|
      hash = {
          :plugin => PLUGINS.plugins[plugin.plugin_name.to_sym],
          :settings => plugin.settings
      }
      @instrument_plugins << hash
    end

    composed_part.effect_plugins.each do |effect_plugin|
      hash = {
          :plugin => PLUGINS.plugins[plugin.plugin_name.to_sym],
          :settings => plugin.settings
      }
      @effect_plugins << hash
    end
    
    @instruction_sequences = []
    
    composed_part.note_sequences.each do |note_sequence|
      @instruction_sequences += make_instruction_sequences_from_note_sequence(note_sequence)
    end
    
    @instruction_sequences.each do |seq|
      raise "instruction sequence #{seq} has no END" unless seq.has_end
    end
    
  end
  
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
        next_note = sequence.notes[i + 1]
        
        case note.relationship
        when Note::RELATIONSHIP_NONE
          seq.end offset + note.duration
          seq = nil
  #      when Note::RELATIONSHIP_TIE
  #        seq.push Instruction.new(Instruction::OFF, offset + note.duration)
        when Note::RELATIONSHIP_SLUR
          seq.add Instruction.new(Instruction::CHANGE_PITCH, offset + note.duration, next_note)
        when Note::RELATIONSHIP_LEGATO
          seq.add Instruction.new(Instruction::CHANGE_PITCH, offset + note.duration, next_note)
          seq.add Instruction.new(Instruction::RESTART_ATTACK, offset + note.duration, next_note)
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

end

end
