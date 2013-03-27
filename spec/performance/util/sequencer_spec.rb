require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Sequencer do
  describe '.extract_note_sequences_from_part' do
    context 'part with no links between notes' do
      before :all do
        non_linked_part = Part.new(
          :note_groups => [
            { :duration => 0.25, :notes => [ { :pitch => PitchConstants::C2 }, { :pitch => PitchConstants::E2 } ] },
            { :duration => 0.25, :notes => [ { :pitch => PitchConstants::D2 }, { :pitch => PitchConstants::F2 } ] },
            { :duration => 0.25, :notes => [ { :pitch => PitchConstants::E2 }, { :pitch => PitchConstants::G2 } ] },
          ]
        )
        @sequences = Sequencer.extract_note_sequences_from_part non_linked_part
      end
      
      it 'should seperate each note from each group into its own sequence' do
        @sequences.count.should eq(6)
        @sequences[0].notes.count.should eq(1)
        @sequences[0].notes[0].pitch.should eq(PitchConstants::C2)
        @sequences[1].notes.count.should eq(1)
        @sequences[1].notes[0].pitch.should eq(PitchConstants::E2)
        @sequences[2].notes.count.should eq(1)
        @sequences[2].notes[0].pitch.should eq(PitchConstants::D2)
        @sequences[3].notes.count.should eq(1)
        @sequences[3].notes[0].pitch.should eq(PitchConstants::F2)
        @sequences[4].notes.count.should eq(1)
        @sequences[4].notes[0].pitch.should eq(PitchConstants::E2)
        @sequences[5].notes.count.should eq(1)
        @sequences[5].notes[0].pitch.should eq(PitchConstants::G2)
      end
      
    end
    
    context 'part with some links between notes' do
      before :all do
        semi_linked_part = Part.new(
          :note_groups => [
            { :duration => 0.25, :notes => [ { :pitch => PitchConstants::C2, :link => { :target_pitch => PitchConstants::D2, :relationship => NoteLink::RELATIONSHIP_SLUR }} ] },
            { :duration => 0.25, :notes => [ { :pitch => PitchConstants::D2, :link => { :target_pitch => PitchConstants::E2, :relationship => NoteLink::RELATIONSHIP_SLUR }} ] },
            { :duration => 0.25, :notes => [ { :pitch => PitchConstants::E2 }, { :pitch => PitchConstants::G2 } ] },
          ]
        )
        @sequences = Sequencer.extract_note_sequences_from_part semi_linked_part
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
          :note_groups => [
            { :duration => 0.25,
              :notes => [
                { :pitch => PitchConstants::C2, :link => { :target_pitch => PitchConstants::D2, :relationship => NoteLink::RELATIONSHIP_SLUR }},
              ]
            },
            { :duration => 0.5,
              :notes => [
                { :pitch => PitchConstants::D2 },
                { :pitch => PitchConstants::F2 },
              ]
            },
            { :duration => 0.25 },
            { :duration => 0.25,
              :notes => [
                { :pitch => PitchConstants::D2 },
                { :pitch => PitchConstants::F2, :link => { :target_pitch => PitchConstants::F2, :relationship => NoteLink::RELATIONSHIP_TIE } },
              ]
            },
            { :duration => 0.25,
              :notes => [
                { :pitch => PitchConstants::F2, :link => { :target_pitch => PitchConstants::F2, :relationship => NoteLink::RELATIONSHIP_TIE } },
              ]
            },
            { :duration => 0.25,
              :notes => [
                { :pitch => PitchConstants::D2, :link => { :target_pitch => PitchConstants::D2, :relationship => NoteLink::RELATIONSHIP_TIE } },
                { :pitch => PitchConstants::F2, :link => { :target_pitch => PitchConstants::E2, :relationship => NoteLink::RELATIONSHIP_SLUR } },
              ]
            },
            { :duration => 0.25,
              :notes => [
                { :pitch => PitchConstants::D2 },
                { :pitch => PitchConstants::E2 },
              ]
            },
          ]
        )
        @sequences = Sequencer.extract_note_sequences_from_part complex_part
      end

      it 'should produce...' do
        @sequences.count.should eq(5)
        @sequences[0].notes.count.should eq(2)
        @sequences[0].notes[0].pitch.should eq(PitchConstants::C2)
        @sequences[0].notes[1].pitch.should eq(PitchConstants::D2)
        
        @sequences[1].notes.count.should eq(1)
        @sequences[1].notes[0].pitch.should eq(PitchConstants::F2)
        
        @sequences[2].notes.count.should eq(1)
        @sequences[2].notes[0].pitch.should eq(PitchConstants::D2)
        
        @sequences[3].notes.count.should eq(4)
        @sequences[3].notes[0].pitch.should eq(PitchConstants::F2)
        @sequences[3].notes[1].pitch.should eq(PitchConstants::F2)
        @sequences[3].notes[2].pitch.should eq(PitchConstants::F2)
        @sequences[3].notes[3].pitch.should eq(PitchConstants::E2)
        
        @sequences[4].notes.count.should eq(2)
        @sequences[4].notes[0].pitch.should eq(PitchConstants::D2)
        @sequences[4].notes[1].pitch.should eq(PitchConstants::D2)
      end
    end
  end
  
  describe '.make_intermediate_sequence_from_note_sequence' do
    context 'produce intermediate sequences for a single note sequence' do
      before :all do
        seq = NoteSequence.new(
          :offset => 0.0,
          :notes => [ Note.new(:duration => 0.25, :pitch => PitchConstants::C3) ]
        )
        @intermediate_sequence = Sequencer.make_intermediate_sequence_from_note_sequence seq
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequence.start_offset.should eq(0.0)
        @intermediate_sequence.has_end?.should be_true
        @intermediate_sequence.end_offset.should eq(0.25)
      end      
    
      it 'should have no instructions' do
        @intermediate_sequence.instructions.count.should eq(0)
      end
    end
    
    context 'produce intermediate sequence for a two-note sequence (connected by legato)' do
      before :all do
        seq = NoteSequence.new(
          :offset => 0.0,
          :notes => [
            Note.new(:duration => 0.25, :pitch => PitchConstants::C3, :link => legato_link(PitchConstants::D3)),
            Note.new(:duration => 0.25, :pitch => PitchConstants::D3),
          ]
        )
        @intermediate_sequence = Sequencer.make_intermediate_sequence_from_note_sequence seq
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequence.start_offset.should eq(0.0)
        @intermediate_sequence.has_end?.should be_true
        @intermediate_sequence.end_offset.should eq(0.5)
      end      
    
      it 'should have two instructions' do
        @intermediate_sequence.instructions.count.should eq(2)
      end
    end
    
    context 'produce intermediate sequences for a two-note sequence (connected by slur)' do
      before :all do
        seq = NoteSequence.new(
          :offset => 0,
          :notes => [
            Note.new(:duration => 0.25, :pitch => PitchConstants::C3, :link => slur_link(PitchConstants::D3)),
            Note.new(:duration => 0.25, :pitch => PitchConstants::D3),
          ]
        )
        @intermediate_sequence = Sequencer.make_intermediate_sequence_from_note_sequence seq
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequence.start_offset.should eq(0.0)
        @intermediate_sequence.has_end?.should be_true
        @intermediate_sequence.end_offset.should eq(0.5)
      end      
    
      it 'should have one instruction' do
        @intermediate_sequence.instructions.count.should eq(1)
      end
    end
    
    context 'produce intermediate sequence for two notes connected by glissando' do
      before :all do
        seq = NoteSequence.new(
          :offset => 0,
          :notes => [
            Note.new(:duration => 0.25, :pitch => PitchConstants::C3, :link => glissando_link(PitchConstants::D3)),
            Note.new(:duration => 0.25, :pitch => PitchConstants::D3),
          ]
        )
        @intermediate_sequence = Sequencer.make_intermediate_sequence_from_note_sequence seq
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequence.start_offset.should eq(0.0)
        @intermediate_sequence.has_end?.should be_true
        @intermediate_sequence.end_offset.should eq(0.5)
      end
      
      it 'should have four instructions' do
        @intermediate_sequence.instructions.count.should eq(4)
      end
    end
  end
end
