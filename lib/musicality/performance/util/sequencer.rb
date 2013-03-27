module Musicality

# Utility class used by Sequencer in transforming a Part into IntermediateSequence objects.
class NoteSequence
  include Hashmake::HashMakeable
  attr_reader :offset, :notes
  
  # define how hashed args may be used to initialize a new instance.
  ARG_SPECS = {
    :offset => arg_spec(:reqd => true, :type => Numeric),
    :notes => arg_spec_array(:reqd => false, :type => Note)
  }
  
  def initialize args
    hash_make ARG_SPECS, args
  end
end

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

# Works to transform a Part object into IntermediateSequence objects.
# The .extract_note_sequences_from_part method first turns a Part into
# NoteSequence objects. Then each NoteSequence object is turned into an
# IntermediateSequence object using .make_intermediate_sequence_from_note_sequence.
class Sequencer
  # Extract note sequences from a part. Notes sequences
  # are mapped to offsets.
  def self.extract_note_sequences_from_part part
    part = Marshal.load(Marshal.dump(part)) # duplicate since it's going to be modified in the process
    
    part.note_groups.each do |group|
      group.clear_duplicates
    end

    offset = part.start_offset
    sequences = []
    
    part.note_groups.each_index do |i|
      group = part.note_groups[i]
      group.notes.each do |note|
        sequence = NoteSequence.new :offset => offset, :notes => [note]
        if note.linked?
          continue_sequence sequence, part.note_groups, i+1
        end
        sequences.push(sequence)
      end
      offset += group.duration
    end
    
    return sequences
  end
  
  def self.make_intermediate_sequence_from_note_sequence note_seq
    raise ArgumentError, "note sequence contains no notes" if note_seq.notes.empty?
    
    for n in 0...(note_seq.notes.count - 1)
      raise ArgumentError, "one of the non-last note sequence notes has no relationship" unless note_seq.notes[n].linked?
    end
    
    offset = note_seq.offset
    seq = nil
    
    # First pass to create sequence. A sequence starts with ON and ends
    # with OFF, and in between is CHANGE_PITCH and RESTART_ATTACK instructions.
    for i in 0...note_seq.notes.count
      prev_relationship = note_seq.notes[i-1].link.relationship
      note = note_seq.notes[i]
      duration = note.duration
      
      if seq.nil?
        seq = IntermediateSequence.new offset, note
      elsif (prev_relationship == NoteLink::RELATIONSHIP_TIE) or
            (prev_relationship == NoteLink::RELATIONSHIP_SLUR) or
            (prev_relationship == NoteLink::RELATIONSHIP_PORTAMENTO)
        seq.add offset, Instructions::ChangePitch, note
      elsif (prev_relationship == NoteLink::RELATIONSHIP_LEGATO) or
            (prev_relationship == NoteLink::RELATIONSHIP_GLISSANDO)
        seq.add offset, Instructions::ChangePitch, note
        seq.add offset, Instructions::RestartAttack, note
      else
        raise "prev_relationship #{prev_relationship} not supported"
      end
      
      if i != (note_seq.notes.count - 1)  # on the last note of sequence, ignore relationship and just end the instruction sequence
        next_note = note_seq.notes[i+1]
        relationship = note.link.relationship
        if (relationship == NoteLink::RELATIONSHIP_GLISSANDO) ||
           (relationship == NoteLink::RELATIONSHIP_PORTAMENTO)
          
          if (relationship == NoteLink::RELATIONSHIP_GLISSANDO)
            subnote_count = (next_note.pitch - note.pitch).total_semitone.abs
          elsif (relationship == NoteLink::RELATIONSHIP_PORTAMENTO)
            cent_step_size = 5
            cents = (next_note.pitch - note.pitch).total_cent
            subnote_count = cents.abs / cent_step_size
          end
          
          subnote_duration = duration / subnote_count
          
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
            #subnote.duration = duration

            seq.add current_offset, Instructions::ChangePitch, subnote
            
            if (relationship == NoteLink::RELATIONSHIP_GLISSANDO)
              seq.add current_offset, Instructions::RestartAttack, subnote
            end
          end
        end
      end
      
      offset += duration
    end

    seq.end offset
    return seq
  end
  
  private
  
  def self.continue_sequence sequence, note_groups, index
    group = note_groups[index]
    
    if group.nil?
      return
    end
    
    target_pitch = sequence.notes.last.link.target_pitch
    group.notes.each_index do |n|
      note = group.notes[n]
      if target_pitch == note.pitch
        sequence.notes.push note
        
        if note.linked?
          continue_sequence sequence, note_groups, index + 1
        end
        
        group.notes.delete_at n
        break
      end
    end
  end
end
end
