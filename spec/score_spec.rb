require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Score do
  before :each do
    @parts = { "piano (LH)" => Samples::SAMPLE_PART }
    @program = Program.new [0...0.75, 0...0.75]
  end
  
  describe '.new' do
    it "should assign part and program given during construction" do
      score = Score.new parts: @parts, program: @program
      score.parts.should eq(@parts)
      score.program.should eq(@program)
    end

    it "should assign tempo profile given during construction" do
      profile = Profile.new(Tempo.new(200), 0.5 => Change::Gradual.new(Tempo.new(120),0.5) )
      score = Score.new tempo_profile: profile
      score.tempo_profile.should eq(profile)
    end    
  end
end
