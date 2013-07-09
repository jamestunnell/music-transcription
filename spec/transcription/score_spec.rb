require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Musicality::Score do
  before :each do
    @parts = { "piano (LH)" => Samples::SAMPLE_PART }
    @program = Musicality::Program.new :segments => [0...0.75, 0...0.75]
  end
  
  describe '.new' do
    context "no args given" do
      let(:score) { Score.new }
      subject { score }
      its(:program) { should eq(Program.new) }
      its(:parts) { should be_empty }
    end
    
    context 'args given' do
      it "should assign parts given during construction" do
        score = Musicality::Score.new :program => @program, :parts => @parts
        score.parts.should eq(@parts)
      end
      
      it "should assign program given during construction" do
        score = Musicality::Score.new :program => @program
        score.program.should eq(@program)
      end      
    end
  end
end

describe Musicality::TempoScore do
  before :each do
    @parts = { "piano (LH)" => Samples::SAMPLE_PART }
    @program = Musicality::Program.new :segments => [0...0.75, 0...0.75]
    @tempo_profile = Musicality::Profile.new(
      :start_value => tempo(120),
      :value_changes => {
        0.5 => Musicality::linear_change(tempo(60), 0.25)
      }
    )
  end
  
  describe '.new' do
    it "should assign tempo profile given during construction" do
      score = Musicality::TempoScore.new :tempo_profile => @tempo_profile
      score.tempo_profile.should eq(@tempo_profile)
    end
    
    it "should assign part and program given during construction" do
      score = Musicality::TempoScore.new :tempo_profile => @tempo_profile, :parts => @parts, :program => @program
      score.parts.should eq(@parts)
      score.program.should eq(@program)
    end
  end
end
