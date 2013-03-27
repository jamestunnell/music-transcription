require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Note do
  before :all do
    @pitch = PitchConstants::C4
  end
  
  context '.new' do
    it 'should assign :pitch and :duration that is given during construction' do
      note = Note.new :pitch => @pitch, :duration => 2
      note.pitch.should eq(@pitch)
      note.duration.should eq(2)
    end
    
    it "should assign :sustain, :attack, and :seperation parameters if given during construction" do
      note = Note.new :pitch => @pitch, :duration => 2, :sustain => 0.1, :attack => 0.2, :seperation => 0.3
      note.sustain.should eq(0.1)
      note.attack.should eq(0.2)
      note.seperation.should eq(0.3)
    end
  
    it "should assign :link parameter if given during construction" do
      link = NoteLink.new(:relationship => NoteLink::RELATIONSHIP_TIE, :target_pitch => @pitch)
      note = Note.new :pitch => @pitch, :duration => 2, :link => link
      note.link.should eq(link)
    end
  end

  context '#pitch=' do
    it "should assign pitch" do
      note = Note.new :pitch => @pitch, :duration => 2
      note.pitch = @pitch = PitchConstants::Gb4
      note.pitch.should eq PitchConstants::Gb4
    end
  end
  
  context '#sustain=' do
    it "should assign sustain" do
      note = Note.new :pitch => @pitch, :duration => 2
      note.sustain = 0.123
      note.sustain.should eq 0.123
    end
  end

  context '#attack=' do
    it "should assign attack" do
      note = Note.new :pitch => @pitch, :duration => 2
      note.attack = 0.123
      note.attack.should eq 0.123
    end
  end
  
  context '#seperation=' do
    it "should assign seperation" do
      note = Note.new :pitch => @pitch, :duration => 2
      note.seperation = 0.123
      note.seperation.should eq 0.123
    end
  end
  
  context '#link=' do
    it "should assign link" do
      link = NoteLink.new(:relationship => NoteLink::RELATIONSHIP_SLUR, :target_pitch => PitchConstants::G2)
      note = Note.new :pitch => @pitch, :duration => 2
      note.link = link
      note.link.should eq(link)
    end
  end
  
  it "should be hash-makeable" do
    Hashmake::hash_makeable?(Note).should be_true
  
    hash = {
      :pitch => @pitch,
      :duration => 2,
      :attack => 0.2,
      :seperation => 0.6,
      :link => {
        :relationship => NoteLink::RELATIONSHIP_TIE,
        :target_pitch => {
          :octave => 2, :semitone => 3
        }
      }
    }
    note = Note.new hash
    note2 = Note.new note.make_hash
    note.should eq(note2)
  end
end
