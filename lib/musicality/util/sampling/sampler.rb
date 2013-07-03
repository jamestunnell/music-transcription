require 'wavefile'
require 'fileutils'

module Musicality
class Sampler
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :output_dir => arg_spec(:reqd => true, :type => String, :validator => ->(a){ a.length > 0 }),
  }
  
  attr_reader :output_dir
  
  def initialize args
    hash_make args, Sampler::ARG_SPECS
    unless Dir.exist?(@output_dir)
      FileUtils.mkdir_p(@output_dir)
    end
  end
  
  def render_wav instrument_config, sample_file
    sample_file.file_name.concat(".wav") if sample_file.file_name !~ /\.wav/
    tgt_path = "#{@output_dir}/#{sample_file.file_name}"
    format = WaveFile::Format.new(:mono, :float_32, sample_file.sample_rate)
    
    WaveFile::Writer.new(tgt_path, format) do |writer|
      render(instrument_config, sample_file) do |new_samples|
        buffer = WaveFile::Buffer.new(new_samples, format)
        writer.write(buffer)
      end
    end
    
    return sample_file
  end
  
  private
  
  def render instrument_config, sample_file
    note = Musicality::Note.new(
      :duration => sample_file.duration_sec,
      :attack => sample_file.attack,
      :sustain => sample_file.sustain,
      :separation => sample_file.separation,
      :intervals => [ Interval.new(:pitch => sample_file.pitch) ]
    )
    
    arrangement = Musicality::Arrangement.new(
      :score => Score.new(
        :parts => {
          1 => Part.new(
            :loudness_profile => Profile.new( :start_value => 1.0 ),
            :notes => [note]
          )
        }
      ),
      :instrument_configs => {
        1 => instrument_config
      }
    )
    
    time_conversion_sample_rate = (250.0 / sample_file.duration_sec).to_i
    conductor = Musicality::Conductor.new(
      :arrangement => arrangement,
      :time_conversion_sample_rate => time_conversion_sample_rate,
      :rendering_sample_rate => sample_file.sample_rate,
      :sample_chunk_size => 100,
    )
    
    samples = []
    if block_given?
      conductor.perform do |new_samples|
        yield new_samples
      end      
    else
      samples = conductor.perform
    end
    
    return samples
  end
end
end
