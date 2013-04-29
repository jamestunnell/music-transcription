require 'wavefile'

module Musicality
class Sampler
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :output_dir => arg_spec(:reqd => true, :type => String, :validator => ->(a){ a.length > 0 }),
  }
  
  attr_reader :output_dir
  
  def initialize args
    hash_make Sampler::ARG_SPECS, args
    Dir.mkdir(@output_dir) unless Dir.exist?(@output_dir)
  end
  
  def render sample_file
    tempo_bpm = 120.0
    beat_duration = 0.25
    notes_per_sec = (tempo_bpm / 60.0) * beat_duration
    note_duration = sample_file.duration_sec * notes_per_sec

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
            :notes => []
          }
        }
      },
      :instrument_configs => {
        1 => sample_file.instrument_config
      }
    )
    
    note = Musicality::Note.new(
      :duration => note_duration,
      :attack => sample_file.attack,
      :sustain => sample_file.sustain,
      :separation => sample_file.separation,
      :intervals => [ {:pitch => sample_file.pitch} ]
    )
    
    arrangement.score.parts[1].notes.clear
    arrangement.score.parts[1].notes.push note
    
    sample_file.file_name.concat(".wav") if sample_file.file_name !~ /\.wav/
    tgt_path = "#{@output_dir}/#{sample_file.file_name}"
    format = WaveFile::Format.new(:mono, :float_32, sample_file.sample_rate)
    
    time_conversion_sample_rate = (250.0 / sample_file.duration_sec).to_i
    
    WaveFile::Writer.new(tgt_path, format) do |writer|
      conductor = Musicality::Conductor.new(
        :arrangement => arrangement,
        :time_conversion_sample_rate => time_conversion_sample_rate,
        :rendering_sample_rate => sample_file.sample_rate,
        :sample_chunk_size => 100,
      )
      
      conductor.perform do |new_samples|
        buffer = WaveFile::Buffer.new(new_samples, format)
        writer.write(buffer)
      end
    end
    
    return sample_file
  end
end
end
