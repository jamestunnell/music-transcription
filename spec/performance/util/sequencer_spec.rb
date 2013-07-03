require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Sequencer do
  describe '.extract_note_sequences' do
    context 'part with no links between notes' do
      before :all do
        non_linked_part = Part.new(
          :notes => [
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => C2 ), Interval.new( :pitch => E2 ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => D2 ), Interval.new( :pitch => F2 ) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => E2 ), Interval.new( :pitch => G2 ) ] ),
          ]
        )
        @sequences = Sequencer.extract_note_sequences non_linked_part
      end
      
      it 'should seperate each note from each group into its own sequence' do
        @sequences.count.should eq(6)
        @sequences[0].notes.count.should eq(1)
        @sequences[0].notes[0].intervals.first.pitch.should eq(C2)
        @sequences[1].notes.count.should eq(1)
        @sequences[1].notes[0].intervals.first.pitch.should eq(E2)
        @sequences[2].notes.count.should eq(1)
        @sequences[2].notes[0].intervals.first.pitch.should eq(D2)
        @sequences[3].notes.count.should eq(1)
        @sequences[3].notes[0].intervals.first.pitch.should eq(F2)
        @sequences[4].notes.count.should eq(1)
        @sequences[4].notes[0].intervals.first.pitch.should eq(E2)
        @sequences[5].notes.count.should eq(1)
        @sequences[5].notes[0].intervals.first.pitch.should eq(G2)
      end
      
    end
    
    context 'part with notes that have no intervals (rest)' do
      before :all do
        non_linked_part = Part.new(
          :offset => 0.0,
          :notes => [
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => C2 ) ] ),
            Note.new( :duration => 0.25 ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => E2 ) ] ),
          ]
        )
        @sequences = Sequencer.extract_note_sequences non_linked_part
      end
      
      it 'should seperate each note from each group into its own sequence' do
        @sequences.count.should eq(2)
        @sequences[0].offset.should eq(0.0)
        @sequences[1].offset.should eq(0.5)
      end
      
    end
    
    context 'part with some links between notes' do
      before :all do
        semi_linked_part = Part.new(
          :notes => [
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => C2, :link => slur(D2)) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => D2, :link => slur(E2)) ] ),
            Note.new( :duration => 0.25, :intervals => [ Interval.new( :pitch => E2 ), Interval.new( :pitch => G2 ) ] ),
          ]
        )
        @sequences = Sequencer.extract_note_sequences semi_linked_part
      end

      it 'should split the notes into two sequences' do
        @sequences.count.should eq(2)
      end
      
      it 'should put all the notes that are linked into the same sequence' do
        @sequences.first.notes.count.should eq(3)
      end
      
      it 'should put the other unlinked note into a different sequence' do
        @sequences.last.notes.count.should eq(1)
      end
    end
    
    context 'part with complext variety of links/non-links between notes' do
      before :all do      
        complex_part = Part.new(
          :notes => [
            Note.new( :duration => 0.25,
              :intervals => [
                Interval.new( :pitch => C2, :link => slur(D2)),
              ]
            ),
            Note.new( :duration => 0.5,
              :intervals => [
                Interval.new( :pitch => D2 ),
                Interval.new( :pitch => F2 ),
              ]
            ),
            Note.new( :duration => 0.25 ),
            Note.new( :duration => 0.25,
              :intervals => [
                Interval.new( :pitch => D2 ),
                Interval.new( :pitch => F2, :link => tie(F2)),
              ]
            ),
            Note.new( :duration => 0.25,
              :intervals => [
                Interval.new( :pitch => F2, :link => tie(F2)),
              ]
            ),
            Note.new( :duration => 0.25,
              :intervals => [
                Interval.new( :pitch => D2, :link => tie(D2)),
                Interval.new( :pitch => F2, :link => slur(E2)),
              ]
            ),
            Note.new( :duration => 0.25,
              :intervals => [
                Interval.new( :pitch => D2 ),
                Interval.new( :pitch => E2 ),
              ]
            ),
          ]
        )
        @sequences = Sequencer.extract_note_sequences complex_part
      end

      it 'should produce...' do
        @sequences.count.should eq(5)
        @sequences[0].notes.count.should eq(2)
        @sequences[0].notes[0].intervals.first.pitch.should eq(C2)
        @sequences[0].notes[1].intervals.first.pitch.should eq(D2)
        
        @sequences[1].notes.count.should eq(1)
        @sequences[1].notes[0].intervals.first.pitch.should eq(F2)
        
        @sequences[2].notes.count.should eq(1)
        @sequences[2].notes[0].intervals.first.pitch.should eq(D2)
        
        @sequences[3].notes.count.should eq(4)
        @sequences[3].notes[0].intervals.first.pitch.should eq(F2)
        @sequences[3].notes[1].intervals.first.pitch.should eq(F2)
        @sequences[3].notes[2].intervals.first.pitch.should eq(F2)
        @sequences[3].notes[3].intervals.first.pitch.should eq(E2)
        
        @sequences[4].notes.count.should eq(2)
        @sequences[4].notes[0].intervals.first.pitch.should eq(D2)
        @sequences[4].notes[1].intervals.first.pitch.should eq(D2)
      end
    end
  end
  
  describe '.make_instructions' do
    context 'a single note sequence' do
      before :all do
        note_seq = NoteSequence.new(
          :offset => 0.0,
          :notes => [ Note.new(:duration => 0.25, :intervals => [ Interval.new(:pitch => C3) ]) ]
        )
        @instructions= Sequencer.make_instructions note_seq
      end
      
      it 'should have two instructions' do
        @instructions.count.should eq(2)
      end
      
      it 'should start with an On instruction where the note sequence starts' do
        @instructions.first.class.should eq(Instructions::On)
        @instructions.first.offset.should eq(0.0)
      end
      
      it 'should end with an Off instruction where the note sequence ends' do
        @instructions.last.class.should eq(Instructions::Off)
        @instructions.last.offset.should eq(0.25)
      end
    end
    
    context 'a two-note sequence (connected by legato)' do
      before :all do
        @note_seq = NoteSequence.new(
          :offset => 0.0,
          :notes => [
            Note.new(:duration => 0.25, :intervals => [ Interval.new(:pitch => C3, :link => legato(D3)) ]),
            Note.new(:duration => 0.25, :intervals => [ Interval.new(:pitch => D3) ], :attack => 0.2, :sustain => 0.7),
          ]
        )
        @instructions = Sequencer.make_instructions @note_seq 
      end

      it 'should have 3 instructions' do
        @instructions.count.should eq(3)
      end
      
      it 'should start with an On instruction where the note sequence starts' do
        @instructions.first.class.should eq(Instructions::On)
        @instructions.first.offset.should eq(0.0)
      end
      
      it 'should end with an Off instruction where the note sequence ends' do
        @instructions.last.class.should eq(Instructions::Off)
        @instructions.last.offset.should eq(0.5)
      end

      it 'should have a Restart instruction in between' do
        @instructions[1].class.should eq(Instructions::Restart)
        @instructions[1].attack.should eq(@note_seq.notes.last.attack)
        @instructions[1].sustain.should eq(@note_seq.notes.last.sustain)
        @instructions[1].pitch.should eq(@note_seq.notes.last.intervals.first.pitch)
      end
    end
    
    context 'a two-note sequence (connected by slur)' do
      before :all do
        @note_seq = NoteSequence.new(
          :offset => 0.0,
          :notes => [
            Note.new(:duration => 0.25, :intervals => [ Interval.new(:pitch => C3, :link => slur(D3)) ]),
            Note.new(:duration => 0.25, :intervals => [ Interval.new(:pitch => D3) ], :attack => 0.2, :sustain => 0.7),
          ]
        )
        @instructions = Sequencer.make_instructions @note_seq 
      end

      it 'should have 3 instructions' do
        @instructions.count.should eq(3)
      end
      
      it 'should start with an On instruction where the note sequence starts' do
        @instructions.first.class.should eq(Instructions::On)
        @instructions.first.offset.should eq(0.0)
      end
      
      it 'should end with an Off instruction where the note sequence ends' do
        @instructions.last.class.should eq(Instructions::Off)
        @instructions.last.offset.should eq(0.5)
      end

      it 'should have an Adjust instruction in between' do
        @instructions[1].class.should eq(Instructions::Adjust)
        @instructions[1].pitch.should eq(@note_seq.notes.last.intervals.first.pitch)
      end
    end
    
    context 'a two-note sequence (connected by glissando), two semitones apart' do
      before :all do
        @note_seq = NoteSequence.new(
          :offset => 0.0,
          :notes => [
            Note.new(:duration => 0.25, :intervals => [ Interval.new(:pitch => C3, :link => glissando(D3)) ]),
            Note.new(:duration => 0.25, :intervals => [ Interval.new(:pitch => D3) ], :attack => 0.2, :sustain => 0.7),
          ]
        )
        @instructions = Sequencer.make_instructions @note_seq
      end

      it 'should have 4 instructions' do
        @instructions.count.should eq(4)
      end
      
      it 'should start with an On instruction where the note sequence starts' do
        @instructions.first.class.should eq(Instructions::On)
        @instructions.first.offset.should eq(0.0)
      end
      
      it 'should end with an Off instruction where the note sequence ends' do
        @instructions.last.class.should eq(Instructions::Off)
        @instructions.last.offset.should eq(0.5)
      end

      it 'should have two Restart instructions in between' do
        @instructions[1].class.should eq(Instructions::Restart)
        (@instructions[1].pitch.total_semitone - @note_seq.notes.first.intervals.first.pitch.total_semitone).should eq(1)
        (@note_seq.notes.last.intervals.first.pitch.total_semitone - @instructions[1].pitch.total_semitone).should eq(1)
        @instructions[1].attack.should eq(@note_seq.notes.first.attack)
        @instructions[1].sustain.should eq(@note_seq.notes.first.sustain)

        @instructions[2].class.should eq(Instructions::Restart)
        (@instructions[2].pitch.total_semitone - @note_seq.notes.first.intervals.first.pitch.total_semitone).should eq(2)
        (@note_seq.notes.last.intervals.first.pitch.total_semitone - @instructions[2].pitch.total_semitone).should eq(0)
        @instructions[2].attack.should eq(@note_seq.notes.last.attack)
        @instructions[2].sustain.should eq(@note_seq.notes.last.sustain)
      end
    end
  end
end
