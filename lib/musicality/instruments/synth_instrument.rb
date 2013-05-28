require 'spcore'

module Musicality

# A simple instrument to use for rendering. Can select different
# ADSR envelope and oscillator voice settings.
class SynthInstrument < Musicality::Instrument
  START_PITCH = C4

  # Helper class to create part of a harmonic structure.
  class Harmonic
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
      hash_make Harmonic::ARG_SPECS, args
      @oscillator = SPCore::Oscillator.new(
        :sample_rate => @sample_rate,
        :amplitude => @amplitude,
        :wave_type => @wave_type,
        :frequency => @fundamental + (@partial * @fundamental)
      )
    end
    
    # Setup the harmonic partial. Can be >= 0.
    def partial= partial
      validate_arg Harmonic::ARG_SPECS[:partial], partial
      @partial = partial
      @oscillator.frequency = @fundamental * (1 + @partial)
    end
    
    # Set up the harmonic fundamental so the oscillator frequency can be set. The formula is: freq = fundamental * (1 + partial).
    def fundamental= fundamental
      validate_arg Harmonic::ARG_SPECS[:fundamental], fundamental
      @fundamental = fundamental
      @oscillator.frequency = @fundamental * (1 + @partial)
    end
    
    # Render one sample from the oscillator.
    def sample
      @oscillator.sample
    end
  end
  
  # Does all the synth action during a performance
  class Handler
    
    TWO_LN_2 = 2 * Math.log(2)
    
    attr_reader :harmonics, :envelope_settings
    
    def initialize sample_rate, harmonic_settings, envelope_settings
      
      @harmonics = []
      harmonic_settings.each do |harmonic_setting|
        @harmonics.push Harmonic.new(
          :sample_rate => sample_rate,
          :fundamental => START_PITCH.freq,
          :partial => harmonic_setting[:partial],
          :wave_type => harmonic_setting[:wave_type],
          :amplitude => harmonic_setting[:amplitude]
        )
      end
      
      @envelope_settings = envelope_settings.clone
      @envelope = ADSREnvelope.new(
        :sample_rate => sample_rate,
        :attack_rate => @envelope_settings[:attack_rate],
        :decay_rate => @envelope_settings[:decay_rate],
        :sustain_level => @envelope_settings[:sustain_level],
        :damping_rate => @envelope_settings[:damping_rate]
      )
    end
    
    # Prepare to start rendering a note.
    def on attack, sustain, pitch
      attack_rate = @envelope_settings[:attack_rate]
      decay_rate = @envelope_settings[:decay_rate]
      sustain_level = @envelope_settings[:sustain_level]
      
      @envelope.reset
      @envelope.attack_rate = (attack_rate / 2.0) * Math.exp(attack * TWO_LN_2)
      @envelope.decay_rate = decay_rate
      @envelope.sustain_level = (sustain_level / 2.0) * Math.exp(sustain * TWO_LN_2)
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
      attack_rate = @envelope_settings[:attack_rate]
      decay_rate = @envelope_settings[:decay_rate]
      sustain_level = @envelope_settings[:sustain_level]
      
      @envelope.attack_rate = (attack_rate / 2.0) * Math.exp(attack * TWO_LN_2)
      @envelope.decay_rate = decay_rate
      @envelope.sustain_level = (sustain_level / 2.0) * Math.exp(sustain * TWO_LN_2)
      @envelope.attack @envelope.envelope
      
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
        
        env = @envelope.render_sample
        
        samples.push(sample * env)
      end
      
      return samples
    end
  end

  def self.assemble_envelope_presets(rate_min, rate_max)
    envelope_presets = {
    }
    
    scale = SPCore::Scale.exponential(rate_min..rate_max, 5)
    
    possibilities = {
      "very short" => scale[4],
      "short" => scale[3],
      "med" => scale[2],
      "long" => scale[1],
      "very long" => scale[0],
    }
    
    # set attack only (default will be used for damping and decay)
    possibilities.each do |attack_len, attack_val|
      envelope_presets["#{attack_len} attack"] = {
        "attack_rate" => attack_val
      }
    end
    
    # set decay only (default will be used for attack and damping)
    possibilities.each do |decay_len, decay_val|
      envelope_presets["#{decay_len} decay"] = {
        "decay_rate" => decay_val
      }
    end

    # set damping only (default will be used for attack and decay)
    possibilities.each do |damping_len, damping_val|
      envelope_presets["#{damping_len} damping"] = {
        "damping_rate" => damping_val
      }
    end
    
    return envelope_presets
  end
  
  include Hashmake::HashMakeable
  
  RATE_MIN = 1.0
  RATE_MAX = 256.0
  DEFAULT_RATE = SPCore::Scale.exponential(RATE_MIN..RATE_MAX, 3)[1]
  ENVELOPE_PRESETS = self.assemble_envelope_presets(RATE_MIN, RATE_MAX)
  
  # define how hashed args may be used to initialize a new instance.
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
    :harmonics => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
  }
  
  def initialize args
    hash_make SynthInstrument::ARG_SPECS, args
    @harmonic_settings = []
    @envelope_settings = {}
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
    
    @envelope_settings[:attack_rate] = DEFAULT_RATE
    @envelope_settings[:decay_rate] = DEFAULT_RATE
    @envelope_settings[:sustain_level] = 0.5
    @envelope_settings[:damping_rate] = DEFAULT_RATE
    
    params["attack_rate"] = SPNet::ParamInPort.new(
      :get_value_handler => ->(){ @envelope_settings[:attack_rate] },
      :set_value_handler => lambda do |attack_rate|
        @envelope_settings[:attack_rate] = attack_rate
        @keys.each do |id,key|
          key.handler.envelope_settings[:attack_rate] = attack_rate
        end
      end,
      :limiter => SPNet::RangeLimiter.new(RATE_MIN, true, RATE_MAX, true)
    )
    
    params["decay_rate"] = SPNet::ParamInPort.new(
      :get_value_handler => ->(){ @envelope_settings[:decay_rate] },
      :set_value_handler => lambda do |decay_val|
        @envelope_settings[:decay_rate] = decay_val
        @keys.each do |id,key|
          key.handler.envelope_settings[:decay_rate] = decay_val
        end
      end,
      :limiter => SPNet::RangeLimiter.new(RATE_MIN, true, RATE_MAX, true)
    )
    
    params["sustain_level"] = SPNet::ParamInPort.new(
      :get_value_handler => ->(){ @envelope_settings[:sustain_level] },
      :set_value_handler => lambda do |sustain_level|
        @envelope_settings[:sustain_level] = sustain_level
        @keys.each {|id,key| key.handler.envelope_settings[:sustain_level] = sustain_level }
      end,
      :limiter => SPNet::RangeLimiter.new(0.0, true, 1.0, true)
    )
    
    params["damping_rate"] = SPNet::ParamInPort.new(
      :get_value_handler => ->(){ @envelope_settings[:damping_rate] },
      :set_value_handler => lambda do |damping_rate|
        @envelope_settings[:damping_rate] = damping_rate
        @keys.each {|id,key| key.handler.envelope_settings[:damping_rate] = damping_rate }
      end,
      :limiter => SPNet::RangeLimiter.new(RATE_MIN, true, RATE_MAX, true)
    )
    
    super(
      :sample_rate => @sample_rate,
      :params => params,
      :key_maker => lambda do
        
        key = Key.new(
          :sample_rate => sample_rate,
          :inactivity_timeout_sec => 0.01,
          :pitch_range => (PITCHES.first..PITCHES.last),
          :start_pitch => START_PITCH,
          :handler => Handler.new(@sample_rate, @harmonic_settings, @envelope_settings)
        )
        
        return key
      end
    )
    
    params["harmonic_0_amplitude"].set_value 1.0
  end

  def self.make_and_register_plugin harmonics, presets = {}
    INSTRUMENTS.register InstrumentPlugin.new(
      :name => "synth_instr_#{harmonics}",
      :version => "1.0.1",
      :author => "James Tunnell",
      :description => "A synthesizer with #{harmonics} harmonic(s) per note.",
      :presets => presets.merge(SynthInstrument::ENVELOPE_PRESETS),
      :maker_proc => lambda do |sample_rate|
        SynthInstrument.new(:harmonics => harmonics, :sample_rate => sample_rate)
      end
    )
  end
end

end