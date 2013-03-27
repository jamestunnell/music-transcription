require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Part do
  context '.new' do
    its(:start_offset) { should eq(0) }
    its(:note_groups) { should be_empty }
    
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
    
    it "should assign note groups given during construction" do
      groups = [
        {
          :duration => 0.25,
          :notes => [
            { :pitch => PitchConstants::C1 },
            { :pitch => PitchConstants::D1 },
          ]
        }
      ]
      
      part = Musicality::Part.new :note_groups => groups
      part.note_groups.should eq(groups)
    end
  end
  
end
