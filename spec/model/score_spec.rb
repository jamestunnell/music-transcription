require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Score do
  before :each do
    notes = [
      {
        :duration => 0.25,
        :intervals => [
          { :pitch => C1 },
          { :pitch => D1 },
        ]
      }
    ]
    
    loudness_profile = Musicality::Profile.new(
      :start_value => 0.5,
      :value_changes => {
        1.0 => Musicality::linear_change(1.0, 2.0)
      }
    )

    @parts = 
    {
      "piano (LH)" => Musicality::Part.new( :loudness_profile => loudness_profile, :notes => notes),
    }

    @tempo_profile = Musicality::Profile.new(
      :start_value => tempo(120),
      :value_changes => {
        0.5 => Musicality::linear_change(tempo(60), 0.25)
      }
    )
    @program = Musicality::Program.new :segments => [0...0.75, 0...0.75]
  end
  
  it "should assign reqd args given during construction" do
    score = Musicality::Score.new :tempo_profile => @tempo_profile, :program => @program
    score.tempo_profile.should eq(@tempo_profile)
    score.program.should eq(@program)
  end

  it "should  default parts to empty" do
    score = Musicality::Score.new :tempo_profile => @tempo_profile, :program => @program
    score.parts.should be_empty
  end

  it "should assign parts given during construction" do
    score = Musicality::Score.new :tempo_profile => @tempo_profile, :program => @program, :parts => @parts
    score.parts.should eq(@parts)
  end
end
