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
  
  describe '#stretch' do
    before :all do
      p = Part.new(
        notes: [ Note::Quarter.new, Note::Whole.new, Note::Eighth.new ],
        dynamic_profile: Profile.new(
          Dynamics::PP,
          "1/2".to_r => Change::Immediate.new(Dynamics::MP),
          "3/4".to_r => Change::Immediate.new(Dynamics::FF)
        )
      )
      @p1 = p.stretch(1)
      @p2 = p.stretch("5/3".to_r)
      @p3 = p.stretch("3/5".to_r)
    end
    
    it 'should multiply durations by ratio' do
      @p1.notes.map {|n| n.duration }.should eq(["1/4".to_r, "1/1".to_r, "1/8".to_r])
      @p2.notes.map {|n| n.duration }.should eq(["5/12".to_r, "5/3".to_r, "5/24".to_r])
      @p3.notes.map {|n| n.duration }.should eq(["3/20".to_r, "3/5".to_r, "3/40".to_r])
    end
    
    it 'should multiply dynamic profile changes by ratio' do
      @p1.dynamic_profile.value_changes.should have_key("1/2".to_r)
      @p1.dynamic_profile.value_changes.should have_key("3/4".to_r)

      @p2.dynamic_profile.value_changes.should have_key("5/6".to_r)
      @p2.dynamic_profile.value_changes.should have_key("15/12".to_r)
      
      @p3.dynamic_profile.value_changes.should have_key("3/10".to_r)
      @p3.dynamic_profile.value_changes.should have_key("9/20".to_r)
    end
  end
  
  describe '#append!' do
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
