require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::NoteSequenceCombiner do
  describe '.combine_note_sequences' do
    before :each do
      hash = {
        :loudness_profile =>
        {
          :start_value => 0.5
        },
        :note_sequences => [
          { :offset => 0.0,
            :notes => [
              { :duration => 0.25, :pitch => { :octave => 9 } },
              { :duration => 0.25, :pitch => { :octave => 9, :semitone => 2 } },
              { :duration => 0.25, :pitch => { :octave => 9, :semitone => 4 } },
              { :duration => 0.25, :pitch => { :octave => 9 } }
            ]
          },
          { :offset => 1.0,
            :notes => [
              { :duration => 1.00, :pitch => { :octave => 9, :semitone => 2 } }
            ]
          }
        ]
      }
      @part = Part.new hash
    end
    
    it "should combine two contiguous sequences into one" do
      NoteSequenceCombiner.combine_note_sequences @part.note_sequences
      
      @part.note_sequences.count.should eq(1)
      @part.note_sequences.first.notes.count.should eq(5)
      @part.note_sequences.first.offset.should eq(0.0)
      @part.note_sequences.first.duration.should eq(2.0)
    end
  end
end
