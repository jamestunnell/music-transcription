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
    hash_make Sampler::ARG_SPECS, args
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
    
    tempo_bpm = 120.0
    beat_duration = 0.25
    notes_per_sec = (tempo_bpm / 60.0) * beat_duration
    note_duration = sample_file.duration_sec * notes_per_sec 
    note = Musicality::Note.new(
      :duration => note_duration,
      :attack => sample_file.attack,
      :sustain => sample_file.sustain,
      :separation => sample_file.separation,
      :intervals => [ {:pitch => sample_file.pitch} ]
    )
    
    arrangement = Musicality::Arrangement.new(
      :score => {
        :program => {
          :segments => [ 0..note_duration ],
        },
        :beats_per_minute_profile => { :start_value => tempo_bpm },
        :beat_duration_profile => { :start_value => beat_duration },
        :parts => {
          1 => {
            :loudness_profile => { :start_value => 1.0 },
            :notes => [note]
          }
        }
      },
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
