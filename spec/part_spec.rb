require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Part do
  context '.new' do
    its(:notes) { should be_empty }
    
    it "should assign loudness_profile profile given during construction" do
      loudness_profile = Profile.new(0.5, 1.0 => linear_change(1.0, 2.0))
      part = Part.new loudness_profile: loudness_profile
      part.loudness_profile.should eq(loudness_profile)
    end  
    
    it "should assign notes given during construction" do
      notes = [ Note.new(0.25, [C1,D1]) ]
      part = Part.new notes: notes
      part.notes.should eq(notes)
    end
  end  
end
