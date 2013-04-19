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

# Works to transform a Part object into IntermediateSequence objects.
# The .extract_note_sequences_from_part method first turns a Part into
# NoteSequence objects. Then each NoteSequence object is turned into an
# IntermediateSequence object using .make_intermediate_sequence_from_note_sequence.
class Sequencer
  # Extract note sequences from a part. Notes sequences
  # are mapped to offsets.
  def self.extract_note_sequences part
    part = Marshal.load(Marshal.dump(part)) # duplicate since it's going to be modified in the process
    
    part.notes.each do |note|
      note.remove_duplicates
    end

    offset = part.start_offset
    sequences = []
    
    part.notes.each_index do |i|
      note = part.notes[i]
      note.intervals.each do |interval|
        
        new_note = note.clone
        new_note.intervals.clear
        new_note.intervals.push interval
        
        sequence = NoteSequence.new :offset => offset, :notes => [new_note]
        if interval.linked?
          continue_sequence sequence, part.notes, i+1
        end
        sequences.push(sequence)
      end
      offset += note.duration
    end
    
    return sequences
  end
  
  def self.make_instructions note_seq
    raise ArgumentError, "note sequence contains no notes" if note_seq.notes.empty?
    
    note_seq.notes.each do |note|
      raise ArgumentError, "note #{note} contains more than one interval" if note.intervals.count > 1
    end
    
    for n in 0...(note_seq.notes.count - 1)
      raise ArgumentError, "one of the non-last note sequence notes has no relationship" unless note_seq.notes[n].intervals.first.linked?
    end
    
    instructions = []
    
    offset = note_seq.offset
    
    # A sequence starts with On instruction and ends with Off, and in between
    # are CHANGE_PITCH and RESTART_ATTACK instructions.
    for i in 0...note_seq.notes.count
      note = note_seq.notes[i]
      duration = note.duration
      
      if instructions.empty?
        instructions.push Instructions::On.new offset, note.attack, note.sustain, note.intervals.first.pitch
      else
        prev_relationship = note_seq.notes[i-1].intervals.first.link.relationship
        
        if (prev_relationship == Link::RELATIONSHIP_TIE) or
            (prev_relationship == Link::RELATIONSHIP_SLUR) or
            (prev_relationship == Link::RELATIONSHIP_PORTAMENTO)
          instructions.push Instructions::Adjust.new offset, note.intervals.first.pitch
        elsif (prev_relationship == Link::RELATIONSHIP_LEGATO) or
            (prev_relationship == Link::RELATIONSHIP_GLISSANDO)
          instructions.push Instructions::Restart.new offset, note.attack, note.sustain, note.intervals.first.pitch
        else
          raise "prev_relationship #{prev_relationship} not supported"
        end
      end
      
      if i != (note_seq.notes.count - 1)  # on the last note of sequence, ignore relationship and just end the instruction sequence
        next_note = note_seq.notes[i+1]
        relationship = note.intervals.first.link.relationship
        if (relationship == Link::RELATIONSHIP_GLISSANDO) ||
           (relationship == Link::RELATIONSHIP_PORTAMENTO)
          
          if (relationship == Link::RELATIONSHIP_GLISSANDO)
            subnote_count = (next_note.intervals.first.pitch - note.intervals.first.pitch).total_semitone.abs
            #binding.pry
          elsif (relationship == Link::RELATIONSHIP_PORTAMENTO)
            cent_step_size = 5
            cents = (next_note.intervals.first.pitch - note.intervals.first.pitch).total_cent
            subnote_count = cents.abs / cent_step_size
            #binding.pry
          end
          
          subnote_duration = duration / subnote_count
          
          cents = (next_note.intervals.first.pitch - note.intervals.first.pitch).total_cent
          raise ArgumentError, "total cent diff #{cents} is not exactly divisible by subnote count #{subnote_count}" unless (cents % subnote_count == 0)
          pitch_incr = Pitch.new(:cent => cents / subnote_count)
          
          current_pitch = note.intervals.first.pitch.clone
          current_offset = offset
          
          (subnote_count - 1).times do
            #binding.pry
            current_pitch += pitch_incr
            current_offset += subnote_duration
            #binding.pry
            
            if (relationship == Link::RELATIONSHIP_PORTAMENTO)
              instructions.push Instructions::Adjust.new current_offset, current_pitch
            elsif (relationship == Link::RELATIONSHIP_GLISSANDO)
              instructions.push Instructions::Restart.new current_offset, note.attack, note.sustain, current_pitch
            end
          end
        end
      end
      
      offset += duration
    end

    instructions.push Instructions::Off.new offset
    return instructions
  end
  
  private
  
  def self.continue_sequence sequence, notes, index
    note = notes[index]
    
    if note.nil?
      return
    end
    
    target_pitch = sequence.notes.last.intervals.first.link.target_pitch
    note.intervals.each_index do |i|
      interval = note.intervals[i]
      if target_pitch == interval.pitch
        new_note = note.clone
        new_note.intervals.clear
        new_note.intervals.push interval
        
        sequence.notes.push new_note
        
        if interval.linked?
          continue_sequence sequence, notes, index + 1
        end
        
        note.intervals.delete_at i
        break
      end
    end
  end
end
end
