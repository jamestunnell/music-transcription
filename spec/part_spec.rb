require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Part do
  context '.new' do
    it 'should have no notes' do
      Part.new.notes.should be_empty
    end

    it "should assign dynamic profile given during construction" do
      profile = Profile.new(Dynamic::FFF, { 1.0 => Change::Immediate.new(Dynamic::PP) })
      part = Part.new dynamic_profile: profile
      part.dynamic_profile.should eq(profile)
    end  
    
    it "should assign notes given during construction" do
      notes = [ Note::Quarter.new([C1,D1]) ]
      part = Part.new notes: notes
      part.notes.should eq(notes)
    end
  end  
end
