require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Part do
  context '.new' do
    it 'should have no notes' do
      Part.new.notes.should be_empty
    end

    it "should assign dynamic profile given during construction" do
      profile = Profile.new(Dynamics::FFF, { 1.0 => Change::Immediate.new(Dynamics::PP) })
      part = Part.new notes:[Note.new(1.to_r)], dynamic_profile: profile
      part.dynamic_profile.should eq(profile)
    end  
    
    it "should assign notes given during construction" do
      notes = [ Note::Quarter.new([C1,D1]) ]
      part = Part.new notes: notes
      part.notes.should eq(notes)
    end
  end
  
  context '#append!' do
    it 'should add other notes to current array' do
      p1 = Part.new(notes: [Note::Eighth.new([C4])])
      p2 = Part.new(notes: [Note::Eighth.new([E4])])
      p1.append! p2
      p1.notes.size.should be 2
      p1.notes[0].pitches[0].should eq C4
      p1.notes[1].pitches[0].should eq E4
    end
    
    it 'should add start dynamic from given part as immediate dynamic change' do
      p1 = Part.new(notes: [Note::Eighth.new])
      p2 = Part.new(notes: [Note::Eighth.new], dynamic_profile: Profile.new(Dynamics::PPP))
      p1.append! p2
      p1.dynamic_profile.value_changes.size.should eq 1
      p1.dynamic_profile.value_changes[Rational(1,8)].should be_a Change::Immediate
      p1.dynamic_profile.value_changes[Rational(1,8)].value.should eq Dynamics::PPP
    end
    
    it 'should add shifted dynamic changes from given part' do
      p1 = Part.new(notes: [Note::Whole.new])
      p2 = Part.new(
        notes: [Note::Whole.new],
        dynamic_profile: Profile.new(
          Dynamics::PPP,
          Rational(1,8) => Change::Gradual.new(Dynamics::PP),
          Rational(2,8) => Change::Immediate.new(Dynamics::P)
        )
      )
      p1.append! p2
      p1.dynamic_profile.value_changes.size.should eq 3
      p1.dynamic_profile.value_changes[Rational(1,1)].value.should eq Dynamics::PPP
      p1.dynamic_profile.value_changes[Rational(9,8)].value.should eq Dynamics::PP
      p1.dynamic_profile.value_changes[Rational(10,8)].value.should eq Dynamics::P
    end
  end
end
