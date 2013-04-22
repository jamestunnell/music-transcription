require 'musicality'
require 'spcore'

module Musicality

# A simple instrument to use for rendering. Can select different
# ADSR envelope and oscillator voice settings.
class SynthInstrument < Musicality::Instrument
  # Helper class to create part of a harmonic structure.
  class SynthHarmonic
    include Hashmake::HashMakeable
    
    # define how hashed args may be used to initialize a new instance.
    ARG_SPECS = {
      :sample_rate => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
      :fundamental => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ a > 0 }),
      :partial => arg_spec(:reqd => false, :type => Fixnum, :default => 0, :validator => ->(a){ a >= 0 }),
      :amplitude => arg_spec(:reqd => false, :type => Numeric, :default => 0.0),
      :wave_type => arg_spec(:reqd => false, :type => Symbol, :default => SPCore::Oscillator::WAVES.first, :validator => ->(a){ SPCore::Oscillator::WAVES.include?(a) })
    }
    
    attr_reader :partial, :oscillator, :fundamental
    
    def initialize args
      hash_make SynthHarmonic::ARG_SPECS, args
      @oscillator = SPCore::Oscillator.new(
        :sample_rate => @sample_rate,
        :amplitude => @amplitude,
        :wave_type => @wave_type,
        :frequency => @fundamental + (@partial * @fundamental)
      )
    end
    
    # Setup the harmonic partial. Can be >= 0.
    def partial= partial
      validate_arg SynthHarmonic::ARG_SPECS[:partial], partial
      @partial = partial
      @oscillator.frequency = @fundamental * (1 + @partial)
    end
    
    # Set up the harmonic fundamental so the oscillator frequency can be set. The formula is: freq = fundamental * (1 + partial).
    def fundamental= fundamental
      validate_arg SynthHarmonic::ARG_SPECS[:fundamental], fundamental
      @fundamental = fundamental
      @oscillator.frequency = @fundamental * (1 + @partial)
    end
    
    # Render one sample from the oscillator.
    def sample
      @oscillator.sample
    end
  end
  
  # Helper class, use to make SynthKey objects.
  class SynthHandler
    attr_reader :harmonics
    
    def initialize harmonics
      @harmonics = harmonics
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
      fundamental = pitch.freq
      @harmonics.each do |harmonic|
        harmonic.fundamental = fundamental
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
        samples << sample
      end
      
      # TODO multiply by envelope
      
      return samples
    end
  end
  
  # Helper class to create a synth instrument key. Creates SynthHarmonic
  # objects, that it uses to make a SynthHandler object, which then performs
  # the actual work of starting/stopping/rendering notes.
  class SynthKey < Key
    def initialize harmonic_count, sample_rate
      start_pitch = C4
      
      harmonics = []
      harmonic_count.times do
        harmonics << SynthHarmonic.new(
          :sample_rate => sample_rate,
          :fundamental => start_pitch.freq
        )
      end
      
      #envelope = # TODO
      handler = SynthHandler.new(harmonics)

      super(
        :sample_rate => sample_rate,
        :inactivity_timeout_sec => 0.01,
        :pitch_range => (PITCHES.first..PITCHES.last),
        :start_pitch => start_pitch,
        :handler => handler
      )
    end
  end

  include Hashmake::HashMakeable
  
  # define how hashed args may be used to initialize a new instance.
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
    :harmonics => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
  }
  
  def initialize args
    hash_make SynthInstrument::ARG_SPECS, args
    @harmonic_settings = []
    
    params = {}
    @harmonics.times do |n|
      @harmonic_settings.push(:partial => 0, :wave_type => SPCore::Oscillator::WAVES.first, :amplitude => 0.0)
      
      params["harmonic_#{n}_partial"] = SPNet::ParamInPort.new(
        :get_value_handler => ->(){ @harmonic_settings[n][:partial] },
        :set_value_handler => lambda do |partial|
          @harmonic_settings[n][:partial] = partial
          @keys.each {|id,key| key.handler.harmonics[n].partial = partial }
        end,
        :limiter => SPNet::LowerLimiter.new(0,true)
      )
      
      params["harmonic_#{n}_wave_type"] = SPNet::ParamInPort.new(
        :get_value_handler => ->(){ @harmonic_settings[n][:wave_type] },
        :set_value_handler => lambda do |wave_type|
          @harmonic_settings[n][:wave_type] = wave_type
          @keys.each {|id,key| key.handler.harmonics[n].oscillator.wave_type = wave_type }
        end,
        :limiter => SPNet::EnumLimiter.new(SPCore::Oscillator::WAVES)
      )
      
      params["harmonic_#{n}_amplitude"] = SPNet::ParamInPort.new(
        :get_value_handler => ->(){ @harmonic_settings[n][:amplitude] },
        :set_value_handler => lambda do |amplitude|
          @harmonic_settings[n][:amplitude] = amplitude
          @keys.each {|id,key| key.handler.harmonics[n].oscillator.amplitude = amplitude }
        end,
      )
    end
    
    super(
      :sample_rate => @sample_rate,
      :params => params,
      :key_maker => lambda do
        key = SynthKey.new(@harmonics, @sample_rate)
        @harmonic_settings.count.times do |n|
          key.handler.harmonics[n].partial = @harmonic_settings[n][:partial]
          key.handler.harmonics[n].oscillator.wave_type = @harmonic_settings[n][:wave_type]
          key.handler.harmonics[n].oscillator.amplitude = @harmonic_settings[n][:amplitude]
        end
        return key
      end
    )
    
    params["harmonic_0_amplitude"].set_value 1.0
  end
end

PLUGINS.register "synth_instr_1".to_sym do
  self.author = "James Tunnell"
  self.version = "1.0.0"
  self.extends = [:instrument]
  #self.requires = [ :oscillator_voice, :flat_envelope ]
  self.extension_points = []
  self.params = { :description => "A synthesizer with 1 harmonic per note)." }

  def make_instrument args
    args = {:harmonics => 1}.merge args
    SynthInstrument.new args
  end
end

PLUGINS.register "synth_instr_3".to_sym do
  self.author = "James Tunnell"
  self.version = "1.0.0"
  self.extends = [:instrument]
  #self.requires = [ :oscillator_voice, :flat_envelope ]
  self.extension_points = []
  self.params = { :description => "A synthesizer with 3 harmonic per note)." }

  def make_instrument args
    args = {:harmonics => 3}.merge args
    SynthInstrument.new args
  end
end

end