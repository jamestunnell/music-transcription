module Musicality

# Takes a composed part, derives information useful for performing, and stores it for
# performer. Converts note sequences to note instruction sequences. Finds plugins using
# plugin configs. Saves loudness profile as-is.
#
# @author James Tunnell
class ArrangedPart
  attr_reader :instruction_sequences, :loudness_profile, :instrument_hash#, :instrument_plugins, :effect_plugins

  def initialize composed_part, instrument_plugin
    @loudness_profile = composed_part.loudness_profile
    @instrument_hash = {
      :plugin => PLUGINS.plugins[instrument_plugin.plugin_name.to_sym],
      :settings => instrument_plugin.settings
    }
    
    #@instrument_plugins = []
    #@effect_plugins = []
    #
    #composed_part.instrument_plugins.each do |plugin|
    #  hash = {
    #      :plugin => PLUGINS.plugins[plugin.plugin_name.to_sym],
    #      :settings => plugin.settings
    #  }
    #  @instrument_plugins << hash
    #end
    #
    #composed_part.effect_plugins.each do |effect_plugin|
    #  hash = {
    #      :plugin => PLUGINS.plugins[plugin.plugin_name.to_sym],
    #      :settings => plugin.settings
    #  }
    #  @effect_plugins << hash
    #end
    
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
    prev_relationship = Note::RELATIONSHIP_NONE
    
    for i in 0...sequence.notes.count do
      note = sequence.notes[i]
      
      if prev_relationship == Note::RELATIONSHIP_NONE
        seq.end(offset) if seq
        seq = InstructionSequence.new(offset, note)
        instr_sequences.push seq
      elsif (prev_relationship == Note::RELATIONSHIP_TIE) or
            (prev_relationship == Note::RELATIONSHIP_SLUR) or
            (prev_relationship == Note::RELATIONSHIP_PORTAMENTO)
        seq.add Instruction.new(Instruction::CHANGE_PITCH, offset, note)
      elsif (prev_relationship == Note::RELATIONSHIP_LEGATO) or
            (prev_relationship == Note::RELATIONSHIP_GLISSANDO)
        seq.add Instruction.new(Instruction::CHANGE_PITCH, offset, note)
        seq.add Instruction.new(Instruction::RESTART_ATTACK, offset, note)        
      else
        raise "prev_relationship #{prev_relationship} not supported"
      end
      
      if i == (sequence.notes.count - 1)  # on the last note of sequence, ignore relationship and just end the instruction sequence
        seq.end offset + note.duration
      else
        next_note = sequence.notes[i + 1]
        
        if (note.relationship == Note::RELATIONSHIP_GLISSANDO)
          semitones = (next_note.pitch - note.pitch).total_semitone          
          semitones_abs = semitones.abs
          
          current_pitch = note.pitch.clone
          pitch_mod = Pitch.new(:semitone => (semitones / semitones_abs))
          
          current_offset = offset
          sub_note_duration = note.duration / semitones_abs
          (semitones_abs - 1).times do
            current_offset += sub_note_duration
            current_pitch += pitch_mod

            sub_note = note.clone
            sub_note.pitch = current_pitch
            sub_note.duration = sub_note_duration
            
            seq.add Instruction.new(Instruction::CHANGE_PITCH, current_offset, sub_note)
            seq.add Instruction.new(Instruction::RESTART_ATTACK, current_offset, sub_note)
          end
        elsif (note.relationship == Note::RELATIONSHIP_PORTAMENTO)
          cent_step_size = 5
          cents = (next_note.pitch - note.pitch).total_cent
          cents_abs = cents.abs
          
          current_pitch = note.pitch.clone
          pitch_mod = Pitch.new(:cent => (cent_step_size * cents) / cents_abs)
          
          current_offset = offset
          sub_note_duration = (cent_step_size * note.duration) / cents_abs
          ((cents_abs / cent_step_size) - 1).times do
            current_offset += sub_note_duration
            current_pitch += pitch_mod

            sub_note = note.clone
            sub_note.pitch = current_pitch
            sub_note.duration = sub_note_duration
            
            seq.add Instruction.new(Instruction::CHANGE_PITCH, current_offset, sub_note)
          end
        end
      end
      
      prev_relationship = note.relationship
      offset += note.duration      
    end
      
    return instr_sequences
  end

end

end
