require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Part do
  context '.new' do
    its(:start_offset) { should eq(0) }
    its(:notes) { should be_empty }
    
    it "should assign loudness profile given during construction" do
      loudness_profile = Musicality::SettingProfile.new(
        :start_value => 0.5,
        :value_change_events => [
          Musicality::Event.new(1.0, 1.0, 2.0)
        ]
      )
  
      part = Musicality::Part.new :loudness_profile => loudness_profile
      part.loudness_profile.should eq(loudness_profile)
    end  
    
    it "should assign notes given during construction" do
      notes = [
        {
          :duration => 0.25,
          :intervals => [
            { :pitch => PitchConstants::C1 },
            { :pitch => PitchConstants::D1 },
          ]
        }
      ]
      
      part = Musicality::Part.new :notes => notes
      part.notes.should eq(notes)
    end
  end
  
end
