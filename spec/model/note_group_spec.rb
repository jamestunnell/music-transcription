require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::NoteGroup do
  context '.new' do
    it 'should assign the given duration' do
      NoteGroup.new(:duration => 3.2).duration.should eq(3.2)
    end
    
    it 'should have no notes by default' do
      NoteGroup.new(:duration => 3.2).notes.should be_empty
    end
    
    it 'should assign the given notes' do
      notes = [
        {:pitch => PitchConstants::C0},
        {:pitch => PitchConstants::E0},
        {:pitch => PitchConstants::G0},
      ]
      NoteGroup.new(:duration => 3.2, :notes => notes).notes.should eq(notes)
    end
    
    it 'should remove all but the last of any notes that have duplicate pitch' do
      notes = [
        { :pitch => PitchConstants::C0 },
        { :pitch => PitchConstants::D0 },
        { :pitch => PitchConstants::G0 },
        { :pitch => PitchConstants::G0 },
        { :pitch => PitchConstants::D0 },
        { :pitch => PitchConstants::C0 },
      ]
      group = NoteGroup.new(:duration => 3.2, :notes => notes)
      group.notes.count.should eq(3)
      group.notes[0].pitch.should eq(PitchConstants::G0)
      group.notes[1].pitch.should eq(PitchConstants::D0)
      group.notes[2].pitch.should eq(PitchConstants::C0)
    end
  end
end