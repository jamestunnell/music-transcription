require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Part do
  before :each do
    @note1 = Musicality::Note.new :pitches => [Pitch.new], :duration => 0.25
    @note2 = Musicality::Note.new :pitches => [Pitch.new], :duration => 0.25
    @note3 = Musicality::Note.new :pitches => [Pitch.new], :duration => 0.25

    @sequences = [ 
      Musicality::Sequence.new( :offset => 0.0, :notes => [@note1, @note2, @note3] )
    ]
    
    @loudness_profile = Musicality::SettingProfile.new(
      :start_value => 0.5,
      :value_change_events => [
        Musicality::Event.new(1.0, 1.0, 2.0)
      ]
    )
    
    @id = "xyz"
  end
  
  it "should assign loudness profile given during construction" do
    part = Musicality::Part.new :loudness_profile => @loudness_profile
    part.loudness_profile.should eq(@loudness_profile)
  end  
  
  it "should assign note sequences given during construction" do
    part = Musicality::Part.new :sequences => @sequences
    part.sequences.should eq(@sequences.clone)
  end
  
  it "should assign id given during construction" do
    part = Musicality::Part.new :start_dynamic => @start_dynamic, :id => @id
    part.id.should eq(@id)
  end
end
