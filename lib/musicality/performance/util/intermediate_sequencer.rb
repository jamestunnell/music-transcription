require 'pry'

module Musicality

# An On/off sequence, with optional instructions to change pitch 
# or restart attack. Creating a new instance will get the sequence
# started. Then instructions can be added (call #add). After that,
# the sequence must be ended (call #end).
class IntermediateSequence
  attr_reader :start_offset, :end_offset, :start_note, :instructions
  
  # A new instance of IntermediateSequence.
  def initialize start_offset, start_note
    @start_offset = start_offset
    @start_note = start_note
    @end_offset = nil
    
    @instructions = []
  end
  
  # check if the sequence has been ended yet
  def has_end?
    !@end_offset.nil?
  end
  
  # end the sequence
  def end offset
    raise "sequence already ended" if has_end?
    @end_offset = offset
  end
  
  # add a ChangePitch or RestartAttack instruction.
  def add offset, klass, note
    raise "sequence already ended" if has_end?
    @instructions.push(:offset => offset, :class => klass, :note => note)
  end
end

# Takes a note_sequence and produces intermediate sequences, each corresponding to
# note on/off (and any pitch changes and restart attacks).
class IntermediateSequencer

  # Takes a note_sequence and produce and array of intermediate sequences. Each
  # IntermediateSequence object corresponds to note on/off and any pitch changes
  # and restart attacks that come in between on/off.
  def self.make_intermediate_sequences_from_note_sequence sequence
    intermediate_sequences = []

    offset = sequence.offset
    seq = nil
    prev_relationship = Note::RELATIONSHIP_NONE
    
    # First pass to create sequences. A sequence starts with ON and ends
    # with OFF, and in between is CHANGE_PITCH and RESTART_ATTACK instructions.
    for i in 0...sequence.notes.count do
      note = sequence.notes[i]
      
      if prev_relationship == Note::RELATIONSHIP_NONE
        if seq
          seq.end offset
        end
        seq = IntermediateSequence.new offset, note
        intermediate_sequences.push seq
      elsif (prev_relationship == Note::RELATIONSHIP_TIE) or
            (prev_relationship == Note::RELATIONSHIP_SLUR) or
            (prev_relationship == Note::RELATIONSHIP_PORTAMENTO)
        seq.add offset, Instructions::ChangePitch, note
      elsif (prev_relationship == Note::RELATIONSHIP_LEGATO) or
            (prev_relationship == Note::RELATIONSHIP_GLISSANDO)
        seq.add offset, Instructions::ChangePitch, note
        seq.add offset, Instructions::RestartAttack, note
      else
        raise "prev_relationship #{prev_relationship} not supported"
      end
      
      if i == (sequence.notes.count - 1)  # on the last note of sequence, ignore relationship and just end the instruction sequence
        seq.end offset + note.duration
      else
        next_note = sequence.notes[i + 1]
        
        if (note.relationship == Note::RELATIONSHIP_GLISSANDO) ||
           (note.relationship == Note::RELATIONSHIP_PORTAMENTO)
          
          if (note.relationship == Note::RELATIONSHIP_GLISSANDO)
            subnote_count = (next_note.pitch - note.pitch).total_semitone.abs
          elsif (note.relationship == Note::RELATIONSHIP_PORTAMENTO)
            cent_step_size = 5
            cents = (next_note.pitch - note.pitch).total_cent
            subnote_count = cents.abs / cent_step_size
          end
          
          subnote_duration = note.duration / subnote_count
          
          cents = (next_note.pitch - note.pitch).total_cent
          raise ArgumentError, "total cent diff #{cents} is not exactly divisible by subnote count #{subnote_count}" unless (cents % subnote_count == 0)
          pitch_incr = Pitch.new(:cent => cents / subnote_count)
            
          current_pitch = note.pitch.clone
          current_offset = offset
          
          (subnote_count - 1).times do
            current_pitch += pitch_incr
            current_offset += subnote_duration
            
            subnote = note.clone  # cloning the original note preserves attack, sustain, etc.
            subnote.pitch = current_pitch
            subnote.duration = subnote_duration

            seq.add current_offset, Instructions::ChangePitch, subnote
            
            if (note.relationship == Note::RELATIONSHIP_GLISSANDO)
              seq.add current_offset, Instructions::RestartAttack, subnote
            end
          end
        end
      end
      
      prev_relationship = note.relationship
      offset += note.duration      
    end
    
    return intermediate_sequences
  end
end

end