require 'musicality'
require 'find'
require 'set'

# A simple instrument to use for rendering. Can select different
# ADSR envelope settings.
class SampledInstrument < Musicality::Instrument
  
  # Helper class, use to make SynthKey objects.
  class SampledHandler
    def initialize sample_files
      @sample_files = sample_files
      @wav_reader = nil
      @sample_file = nil
    end
    
    # Prepare to start rendering a note.
    def on attack, sustain, pitch
      # TODO setup envelope
      
      adjust pitch
    end
    
    # Finish rendering a note.
    def off
      # TODO set envelope to 0
    end
    
    # Start damping a note (so it dies out).
    def release damping
      # TODO setup envelope
    end
    
    # Continute the current note, possibly with new attack, sustain, and pitch.
    def restart attack, sustain, pitch
      # TODO setup envelope
      
      adjust pitch
    end
    
    # Adjust the pitch of the current note.
    def adjust pitch
      applicable = @sample_files.select {|sf| sf.pitch == pitch}
      
      if applicable.any?
        # TODO - find the most suitable sample file
        @sample_file = applicable.first
        @wav_reader = open_sample_file @sample_file
      else
        raise ArgumentError, "pitch #{pitch} is not supported"
      end
    end
    
    # Render the given number of samples.
    def render count
      samples = []
      if count > remaining
        samples = @wav_reader.read(remaining).samples
        count -= remaining
        
        @wav_reader.close
        @wav_reader = open_sample_file @sample_file
      end
      
      if remaining >= count
        samples += @wav_reader.read(count).samples
      else
        raise "Reached end of sample file. Could not render all samples."
      end
      
      if remaining == 0
        @wav_reader.close
        @wav_reader = open_sample_file @sample_file
      end
      
      # TODO multiply by envelope
      
      return samples
    end
    
    private
    
    def remaining
      @wav_reader.total_sample_frames - @wav_reader.current_sample_frame - 1
    end
    
    def open_sample_file sf
      return WaveFile::Reader.new(sf.file_name)
    end
  end
  
  # Helper class to create a synth instrument key. Creates SynthHarmonic
  # objects, that it uses to make a SynthHandler object, which then performs
  # the actual work of starting/stopping/rendering notes.
  class SampledKey < Musicality::Key
    def initialize sample_files, sample_rate
      start_pitch = sample_files.first.pitch
      
      #envelope = # TODO
      handler = SampledHandler.new(sample_files)
      minmax = sample_files.minmax_by {|sf| sf.pitch }
      
      super(
        :sample_rate => sample_rate,
        :inactivity_timeout_sec => 0.01,
        :pitch_range => minmax[0].pitch..minmax[1].pitch,
        :start_pitch => start_pitch,
        :handler => handler
      )
    end
  end

  include Hashmake::HashMakeable
  
  # define how hashed args may be used to initialize a new instance.
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
    :sample_files => arg_spec_array(:reqd => true, :type => Musicality::SampleFile, :validator => ->(a){ File.exist?(a.file_name) }),
  }
  
  def initialize args
    hash_make SampledInstrument::ARG_SPECS, args
    @sample_files = Marshal.load(Marshal.dump(@sample_files))
    @sample_files.keep_if {|sf| sf.sample_rate == @sample_rate }
    
    if @sample_files.empty?
      raise "No sample files exist with a sample rate of #{@sample_rate}"
    end
    
    super(
      :sample_rate => @sample_rate,
      :key_maker => ->(){ return SampledKey.new(@sample_files, @sample_rate) }
    )
  end

  # Make sure the SampleDir relative path has been replaced with an absolute
  # (expanded) path already.
  def self.make_and_register_plugin sample_files, instr_name
    Musicality::INSTRUMENTS.register Musicality::InstrumentPlugin.new(
      :name => instr_name,
      :version => "1.0.0",
      :author => "James Tunnell",
      :description => "Sample files contained in #{instr_name}.",
      :maker_proc => lambda do |sample_rate|
        SampledInstrument.new(:sample_files => sample_files, :sample_rate => sample_rate)
      end
    )
  end
end

root = File.dirname(File.expand_path(__FILE__)) + '/sample_files/'

Find.find(root) do |path|
  if path =~ /\.yml$/
    File.open(path, "r") do |file|
      begin
        sample_files = YAML.load(file.read)
        
        if sample_files.is_a?(Array)
          #sample_files.keep_if {|sf| sf.is_a?(SampleFile) }
        end
        
        if sample_files.any?
          dirname = File.dirname(path)
          sample_files.each do |sf|
            sf.file_name = dirname + '/' + sf.file_name
          end
          
          instr_name = path.gsub(root,"")
          SampledInstrument.make_and_register_plugin sample_files, instr_name
        end
      rescue
        puts "Couldn't load YAML from file #{path}"
      end
    end
  end
end
