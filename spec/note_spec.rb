require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Note do
  before :all do
    @pitch = C4
  end
  
  context '.new' do
    it 'should assign :duration that is given during construction' do
      note = Note.new 2
      note.duration.should eq(2)
    end
    
    it "should assign :accent parameter if given during construction" do
      note = Note.new 2, accent: Accent::Staccato.new
      note.accent.class.should eq(Accent::Staccato)
    end
    
    it 'should have no pitches if not given' do
      Note.new(2).pitches.should be_empty
    end
    
    it 'should assign pitches when given' do
      pitches = [ C2, D2 ]
      n = Note.new(2, pitches)
      n.pitches.should include(pitches[0])
      n.pitches.should include(pitches[1])
    end
  end
  
  context '#duration=' do
    it 'should assign duration' do
      note = Note.new 2, [@pitch]
      note.duration = 3
      note.duration.should eq 3
    end
  end  
end
