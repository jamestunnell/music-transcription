require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Note do
  before :all do
    @pitch = C4
  end
  
  describe '.new' do
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
  
  describe '#duration=' do
    it 'should assign duration' do
      note = Note.new 2, [@pitch]
      note.duration = 3
      note.duration.should eq 3
    end
  end
  
  describe '#transpose!' do
    context 'transpose_link_targets set false' do
      context 'given pitch diff' do
        before(:all) do
          @note = Note::Quarter.new([C2,F2], links:{C2=>Link::Slur.new(D2)})
          @diff = Pitch.new(semitone: 4)
          @note.transpose! @diff, false
        end
        
        it 'should modifiy pitches by adding pitch diff' do
          @note.pitches[0].should eq E2
          @note.pitches[1].should eq A2
        end
        
        it 'should not affect link targets' do
          @note.links.should have_key(E2)
          @note.links[E2].target_pitch.should eq(D2)
        end
      end
      
      context 'given integer diff' do
        it 'should transpose the given number of semitones' do
          Note::Quarter.new([C2]).transpose!(4,false).pitches[0].should eq(E2)
        end
      end
    end
  end
  
  context 'transpose_link_targets set true' do
    it 'should also transpose link targets' do
      note = Note::Quarter.new([C2,F2], links:{C2=>Link::Slur.new(D2)})
      note.transpose!(2,true)
      note.links[D2].target_pitch.should eq(E2)
    end
  end
end
