require 'musicality'

module Musicality

# Render samples of the selected oscillator. Available oscillator types are
# square, triangle, sawtooth, and sine. Oscillator type is selected with the
# :wave_type setting.
class OscillatorVoice
  
  attr_accessor :sample_rate, :wave_type
  include Hashmake::HashMakeable
  
  # A list of the valid oscillator wave types. Currently: square, triangle,
  # sawtooth, and sine.
  VALID_WAVE_TYPES = [
    "square",
    "triangle",
    "sawtooth",
    "sine"
  ]
  
  # required hash-args (for hash-makeable idiom)
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ a > 0.0 } ),
    :wave_type => arg_spec(:reqd => true, :type => SettingProfile, :validator => ->(a){ VALID_WAVE_TYPES.include? a.start_value } )
  }
  
  # A new instance of OscillatorVoice.
  # @param [Hash] settings Hashed arguments. Required keys are :sample_rate
  #                        and :wave_type. See VALID_WAVE_TYPES for a list
  #                        of the valid values for :wave_type.
  def initialize settings
    hash_make ARG_SPECS, settings
    
    wave_type = @wave_type.start_value
    if wave_type == 'square'
      @oscillator = Musicality::SquareWave.new @sample_rate
    elsif wave_type == 'sine'
      @oscillator = Musicality::SineWave.new @sample_rate
    elsif wave_type == 'sawtooth'
      @oscillator = Musicality::SawtoothWave.new @sample_rate
    elsif wave_type == 'triangle'
      @oscillator = Musicality::TriangleWave.new @sample_rate
    else
      raise ArgumentError, "wave_type #{wave_type} is not supported"
    end
    
  end
  
  # Change the oscillator frequency.
  def freq= freq
    @oscillator.freq = freq
  end
  
  # Render a sample of the oscillator.
  def render_sample
    @oscillator.render_sample
  end
end

PLUGINS.register :oscillator_voice do
  self.author = "James Tunnell"
  self.version = "1.0.0"
  self.extends = [:voice]
  #self.requires = []
  self.extension_points = []
  self.params = { :description => "Makes an oscillator-based voice, with selectable wave type." }

  def make_voice settings
    OscillatorVoice.new settings
  end
end

end
