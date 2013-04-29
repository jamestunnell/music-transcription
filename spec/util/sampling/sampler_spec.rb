require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Sampler do

  describe '.new' do
    it 'should assign the given output_dir' do
      Dir.mkdir("mydir")
      
      s = Sampler.new(:output_dir => "mydir")
      s.output_dir.should eq("mydir")
      
      Dir.rmdir("mydir")
    end
    
    it 'should make the given output_dir if it does not exist' do
      Dir.exist?("newdir").should be_false
      
      s = Sampler.new(:output_dir => "newdir")
      s.output_dir.should eq("newdir")
      
      Dir.exist?("newdir").should be_true
      Dir.rmdir("newdir")
    end
  end

  describe '#render' do
    it 'should render the given SampleFile' do
      sf = SampleFile.new(
        :file_name => "abc",
        :sample_rate => 44100,
        :duration_sec => 0.25,
        :instrument_config => {
          :plugin_name => "synth_instr_3",
          :initial_settings => "blend"
        },
        :pitch => "C4".to_pitch,
        :attack => 0.5,
        :sustain => 0.5,
        :separation => 0.5
      )
      
      sampler = Sampler.new(:output_dir => 'mydir')
      sampler.render sf
      
      sf.file_name.should match(/\.wav$/)
      File.exist?('mydir/abc.wav').should be_true
      
      data_size = (sf.sample_rate * sf.duration_sec) * 4  # should be 4 byte (32-bit float) samples
      size = File.size('mydir/abc.wav')
      (size - data_size.to_i).abs.should be < 100
      
      File.delete('mydir/abc.wav')
    end
  end
  
  after :all do
    Dir.rmdir('mydir') if Dir.exist?('mydir')
  end
end
