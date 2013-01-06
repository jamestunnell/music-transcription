module Musicality

# The class responsible for the function of combining different note
# sequences that are actually contiguous.
class NoteSequenceCombiner
  # Given an array of note sequences, combine any note sequences that
  # are actually contiguous (end note of one seq stops when first note
  # of another seq begins).
  def self.combine_note_sequences note_sequences
    i = 0
    while i < note_sequences.count do
      seq_a = note_sequences[i]
      seq_a_end = seq_a.duration + seq_a.offset
      
      note_sequences.each_index do |j|
        seq_b = note_sequences[j]
        seq_b_beg = seq_b.offset 
        
        diff = (seq_b_beg - seq_a_end)
        
        if diff.between?(0.0, 0.001)  # sequences are contiquous, collapse!
          seq_a.notes.last.duration += diff # make sure seq_a ends right at seq_b_beg
          seq_a.notes += seq_b.notes
          
          # remove seq b and restart the loop
          note_sequences.delete_at j
          i = 0
        else
          i += 1
        end
      end
    end
  end
end
end
