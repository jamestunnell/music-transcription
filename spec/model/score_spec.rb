require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Score do
  before :each do
    groups = [
      {
        :duration => 0.25,
        :notes => [
          { :pitch => PitchConstants::C1 },
          { :pitch => PitchConstants::D1 },
        ]
      }
    ]
    
    loudness_profile = Musicality::SettingProfile.new(
      :start_value => 0.5,
      :value_change_events => [
        Musicality::Event.new(1.0, 1.0, 2.0)
      ]
    )

    @parts = 
    {
      "piano (LH)" => Musicality::Part.new( :loudness_profile => loudness_profile, :note_groups => groups),
    }

    @bpm_profile = Musicality::SettingProfile.new(
      :start_value => 120,
      :value_change_events => [
        Musicality::Event.new( 0.5, 60, 0.25 )
      ]
    )
    
    @program = Musicality::Program.new :segments => [0...0.75, 0...0.75]
  end
  
  it "should assign reqd args given during construction" do
    score = Musicality::Score.new :beats_per_minute_profile => @bpm_profile, :program => @program
    score.beats_per_minute_profile.should eq(@bpm_profile)
    score.program.should eq(@program)
  end

  it "should  default parts to empty" do
    score = Musicality::Score.new :beats_per_minute_profile => @bpm_profile, :program => @program
    score.parts.should be_empty
  end

  it "should assign parts given during construction" do
    score = Musicality::Score.new :beats_per_minute_profile => @bpm_profile, :program => @program, :parts => @parts
    score.parts.should eq(@parts)
  end
end
