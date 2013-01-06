require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::IntermediateSequencer do
  describe '.make_intermediate_sequences_from_note_sequence' do
    
    context 'produce intermediate sequences for a single note sequence' do
      before :all do
        seq_one_note = NoteSequence.new(
          :offset => 0.0,
          :notes => [ Note.new(:duration => 0.25, :pitch => PitchConstants::C3) ]
        )

        @intermediate_sequences = IntermediateSequencer.make_intermediate_sequences_from_note_sequence seq_one_note
      end
      
      it 'should produce a single intermediate sequence' do
        @intermediate_sequences.count.should be(1)
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequences.first.start_offset.should eq(0.0)
        @intermediate_sequences.first.has_end?.should be_true
        @intermediate_sequences.first.end_offset.should eq(0.25)
      end      

      it 'should have no instructions' do
        @intermediate_sequences.first.instructions.count.should eq(0)
      end
    end

    context 'produce intermediate sequences for a two-note sequence' do
      before :all do
        seq_two_note = NoteSequence.new(
          :offset => 0.0,
          :notes => [
            Note.new(:duration => 0.25, :pitch => PitchConstants::C3),
            Note.new(:duration => 0.25, :pitch => PitchConstants::D3)
          ]
        )
        @intermediate_sequences = IntermediateSequencer.make_intermediate_sequences_from_note_sequence seq_two_note
      end
      
      it 'should produce two intermediate sequence' do
        @intermediate_sequences.count.should be(2)
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequences.first.start_offset.should eq(0.0)
        @intermediate_sequences.first.has_end?.should be_true
        @intermediate_sequences.first.end_offset.should eq(0.25)
        @intermediate_sequences.last.start_offset.should eq(0.25)
        @intermediate_sequences.last.has_end?.should be_true
        @intermediate_sequences.last.end_offset.should eq(0.5)
      end      

      it 'should have no instructions' do
        @intermediate_sequences.first.instructions.count.should eq(0)
      end
    end

    context 'produce intermediate sequences for a two-note sequence (connected by legato)' do
      before :all do
        seq_two_note_legato = NoteSequence.new(
          :offset => 0.0,
          :notes => [
            Note.new(:duration => 0.25, :pitch => PitchConstants::C3, :relationship => Note::RELATIONSHIP_LEGATO),
            Note.new(:duration => 0.25, :pitch => PitchConstants::D3)
          ]
        )      

        @intermediate_sequences = IntermediateSequencer.make_intermediate_sequences_from_note_sequence seq_two_note_legato
      end
      
      it 'should produce a single intermediate sequence' do
        @intermediate_sequences.count.should be(1)
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequences.first.start_offset.should eq(0.0)
        @intermediate_sequences.first.has_end?.should be_true
        @intermediate_sequences.first.end_offset.should eq(0.5)
      end      

      it 'should have two instructions' do
        @intermediate_sequences.first.instructions.count.should eq(2)
      end      
    end

    context 'produce intermediate sequences for a two-note sequence (connected by slur)' do
      before :all do
        seq_two_note_slur = NoteSequence.new(
          :offset => 0.0,
          :notes => [
            Note.new(:duration => 0.25, :pitch => PitchConstants::C3, :relationship => Note::RELATIONSHIP_SLUR),
            Note.new(:duration => 0.25, :pitch => PitchConstants::D3)
          ]
        )
        @intermediate_sequences = IntermediateSequencer.make_intermediate_sequences_from_note_sequence seq_two_note_slur
      end
      
      it 'should produce a single intermediate sequence' do
        @intermediate_sequences.count.should be(1)
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequences.first.start_offset.should eq(0.0)
        @intermediate_sequences.first.has_end?.should be_true
        @intermediate_sequences.first.end_offset.should eq(0.5)
      end      

      it 'should have one instruction' do
        @intermediate_sequences.first.instructions.count.should eq(1)
      end      
    end

    context 'produce intermediate sequence for four notes, the first then last two connected by slur then legato' do
      before :all do
        seq_four_note_slur_then_legato = NoteSequence.new(
          :offset => 0.0,
          :notes => [
            Note.new(:duration => 0.25, :pitch => PitchConstants::C3, :relationship => Note::RELATIONSHIP_SLUR),
            Note.new(:duration => 0.25, :pitch => PitchConstants::D3),
            Note.new(:duration => 0.25, :pitch => PitchConstants::C3, :relationship => Note::RELATIONSHIP_LEGATO),
            Note.new(:duration => 0.25, :pitch => PitchConstants::D3),
          ]
        )      

        @intermediate_sequences = IntermediateSequencer.make_intermediate_sequences_from_note_sequence seq_four_note_slur_then_legato
      end
      
      it 'should produce two intermediate sequence' do
        @intermediate_sequences.count.should be(2)
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequences.first.start_offset.should eq(0.0)
        @intermediate_sequences.first.has_end?.should be_true
        @intermediate_sequences.first.end_offset.should eq(0.5)
        @intermediate_sequences.last.start_offset.should eq(0.5)
        @intermediate_sequences.last.has_end?.should be_true
        @intermediate_sequences.last.end_offset.should eq(1.0)
      end      

      it 'should have one instruction' do
        @intermediate_sequences.first.instructions.count.should eq(1)
        @intermediate_sequences.last.instructions.count.should eq(2)
      end      
    end

    context 'produce intermediate sequence for two notes connected by glissando' do
      before :all do
        seq = NoteSequence.new(
          :offset => 0.0,
          :notes => [
            Note.new(:duration => 0.25, :pitch => PitchConstants::C3, :relationship => Note::RELATIONSHIP_GLISSANDO),
            Note.new(:duration => 0.25, :pitch => PitchConstants::D3),
          ]
        )      
        @intermediate_sequences = IntermediateSequencer.make_intermediate_sequences_from_note_sequence seq
      end
      
      it 'should produce one intermediate sequences'do
        @intermediate_sequences.count.should be(1)
      end
      
      it 'should set start and end offset according to the notes represented in the intermediate_sequences' do
        @intermediate_sequences.first.start_offset.should eq(0.0)
        @intermediate_sequences.first.has_end?.should be_true
        @intermediate_sequences.first.end_offset.should eq(0.5)
      end
      
      it 'should have four instructions' do
        @intermediate_sequences.first.instructions.count.should eq(4)
      end
    end

  end
end
