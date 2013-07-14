require 'hashmake'
require 'wavefile'
require 'spcore'
require 'musicality'
require 'find'
require 'pry'

# Attempt to reproduce (mimic) the harmonic amplitudes of an audio sample file.
#
# @author James Tunnell
class MimicInstrument < Musicality::Instrument
  include Hashmake::HashMakeable
  
  # Does all the synth action during a performance
  class Handler
    attr_reader :harmonics, :envelope_settings, :partial
    
    def initialize sample_rate, partial_functions, envelope_settings
      
      @harmonics = []
      partial_functions.each do |partial, func|
        @harmonics.push Musicality::SynthInstrument::Harmonic.new(
          :sample_rate => sample_rate,
          :fundamental => Musicality::SynthInstrument::START_PITCH.freq,
          :partial => partial,
        )
      end
      @partial_functions = partial_functions
      
      @envelope_settings = envelope_settings.clone
      @envelope = Musicality::ADSREnvelope.new(
        :sample_rate => sample_rate,
        :attack_rate => @envelope_settings[:attack_rate],
        :decay_rate => @envelope_settings[:decay_rate],
        :sustain_level => @envelope_settings[:sustain_level],
        :damping_rate => @envelope_settings[:damping_rate]
      )
    end
    
    # Prepare to start rendering a note.
    def on attack, sustain, pitch
      #attack_rate = @envelope_settings[:attack_rate]
      #decay_rate = @envelope_settings[:decay_rate]
      #sustain_level = @envelope_settings[:sustain_level]
      #
      #@envelope.reset
      #@envelope.attack_rate = (attack_rate / 2.0) * Math.exp(attack * TWO_LN_2)
      #@envelope.decay_rate = decay_rate
      #@envelope.sustain_level = (sustain_level / 2.0) * Math.exp(sustain * TWO_LN_2)
      @envelope.attack 0.0
      
      adjust pitch
    end
    
    # Finish rendering a note.
    def off
      @envelope.reset
    end
    
    # Start damping a note (so it dies out).
    def release damping
      damping_rate = @envelope_settings[:damping_rate]
      @envelope.damping_rate = (damping_rate / 2.0) * Math.exp(damping * TWO_LN_2)
      @envelope.release
    end
    
    # Continute the current note, possibly with new attack, sustain, and pitch.
    def restart attack, sustain, pitch
      #attack_rate = @envelope_settings[:attack_rate]
      #decay_rate = @envelope_settings[:decay_rate]
      #sustain_level = @envelope_settings[:sustain_level]
      #
      #@envelope.attack_rate = (attack_rate / 2.0) * Math.exp(attack * TWO_LN_2)
      #@envelope.decay_rate = decay_rate
      #@envelope.sustain_level = (sustain_level / 2.0) * Math.exp(sustain * TWO_LN_2)
      @envelope.attack @envelope.envelope
      
      adjust pitch
    end
    
    # Adjust the pitch of the current note.
    def adjust pitch
      fundamental = pitch.freq
      @harmonics.each do |harmonic|
        harmonic.fundamental = fundamental
        ampl = @partial_functions[harmonic.partial].eval(fundamental)
        harmonic.oscillator.amplitude = ampl
      end
    end
    
    # Render the given number of samples.
    def render count
      samples = []
      count.times do
        sample = 0.0
        
        @harmonics.each do |osc|
          sample += osc.sample
        end
        
        env = @envelope.render_sample
        
        samples.push(sample * env)
      end
      
      return samples
    end
  end
  
  MIMIC_SAMPLES_DIR = File.dirname(__FILE__) + '/mimics'
  
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
    :max_harmonics => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
    :file_paths => arg_spec_array(:reqd => true, :type => String, :validator => ->(a){ File.exist? a })
  }
  
  MAX_FFT_SIZE = 8192
  
  def initialize args
    hash_make args, MimicInstrument::ARG_SPECS
    
    partial_settings = {}
    @file_paths.each do |file_path|
      WaveFile::Reader.new(file_path) do |reader|
        raise ArgumentError, "#{file_path} is not a mono wav file" if reader.format.channels > 1
        
        sample_frames = reader.read(reader.total_sample_frames).samples
        signal = SPCore::Signal.new(:data => sample_frames, :sample_rate => reader.format.sample_rate)
        peaks = signal.freq_peaks
        series = signal.harmonic_series
        fund_freq = series.min
        fund_ampl = peaks[fund_freq]
        
        count = 0
        series.each do |freq|
          break if count >= @max_harmonics
          count += 1
          
          partial = ((freq / fund_freq).round - 1)
          ampl = (peaks[freq] / fund_ampl)

          if partial_settings[partial].nil?
            partial_settings[partial] = {}
          end
          
          partial_settings[partial][fund_freq] = ampl
        end
      end      
    end
    
    # for each partial, make a function to calculate amplitude
    @partial_functions = {}
    partial_settings.each do |partial, hash|
      points = []
      hash.each do |fund,ampl|
        points.push [fund,ampl]
      end
      points.unshift [0.0, points.first[1]]
      points.push [@sample_rate, points.last[1]]
      
      @partial_functions[partial] = Musicality::PiecewiseFunction.new(points)
    end
    
    @envelope_settings = {
      :attack_rate => Musicality::SynthInstrument::RATE_MAX,
      :decay_rate => Musicality::SynthInstrument::RATE_MAX,
      :sustain_level => 0.25,
      :damping_rate => Musicality::SynthInstrument::RATE_MAX
    }
    
    super(
      :sample_rate => @sample_rate,
      :key_maker => lambda do
        
        key = Musicality::InstrumentKey.new(
          :sample_rate => @sample_rate,
          :inactivity_timeout_sec => 0.01,
          :pitch_range => (Musicality::PITCHES.first..Musicality::PITCHES.last),
          :start_pitch => Musicality::SynthInstrument::START_PITCH,
          :handler => Handler.new(@sample_rate, @partial_functions, @envelope_settings)
        )
        
        return key
      end
    )
  end
  
  def self.make_and_register_plugin instr_name, file_paths, max_harmonics
    Musicality::INSTRUMENTS.register Musicality::InstrumentPlugin.new(
      :name => "mimic_#{instr_name}",
      :version => "1.0.1",
      :author => "James Tunnell",
      :description => "A synthesizer set up to mimic a #{instr_name}",
      :presets => Musicality::SynthInstrument::ENVELOPE_PRESETS,
      :maker_proc => lambda do |sample_rate|
        MimicInstrument.new(
          :max_harmonics => max_harmonics,
          :sample_rate => sample_rate, 
          :file_paths => file_paths
        )
      end
    )
  end
end

wav_files = Find.find(MimicInstrument::MIMIC_SAMPLES_DIR).to_a.select {|path| path =~ /\.wav$/ }

# seperate wav by first word
related_files = {}
wav_files.each do |wav_file|
  basename = File.basename(wav_file)
  words = basename.split(/[\s_\-\.]+/)
  first_word = words.first
  
  if related_files[first_word].nil?
    related_files[first_word] = [wav_file]
  else
    related_files[first_word].push wav_file
  end
end

related_files.each do |instr_name, file_paths|
  MimicInstrument.make_and_register_plugin instr_name, file_paths, 16
end