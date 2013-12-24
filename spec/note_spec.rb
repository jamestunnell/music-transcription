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
    
    it "should assign :sustain, :attack, and :separation parameters if given during construction" do
      note = Note.new 2, sustain: 0.1, attack: 0.2, separation: 0.3
      note.sustain.should eq(0.1)
      note.attack.should eq(0.2)
      note.separation.should eq(0.3)
    end
    
    it 'should have no pitches if not given' do
      Note.new(2).pitches.should be_empty
    end
    
    it 'should assign pitches when given' do
      pitches = [ C2, D2 ]
      Note.new(2, pitches).pitches.should eq(pitches)
    end
  end
  
  context '#duration=' do
    it 'should assign duration' do
      note = Note.new 2, [@pitch]
      note.duration = 3
      note.duration.should eq 3
    end
  end
  
  context '#sustain=' do
    it "should assign sustain" do
      note = Note.new 2, [@pitch]
      note.sustain = 0.123
      note.sustain.should eq 0.123
    end
  end

  context '#attack=' do
    it "should assign attack" do
      note = Note.new 2, [@pitch]
      note.attack = 0.123
      note.attack.should eq 0.123
    end
  end
  
  context '#separation=' do
    it "should assign separation" do
      note = Note.new 2, [@pitch]
      note.separation = 0.123
      note.separation.should eq 0.123
    end
  end
end
