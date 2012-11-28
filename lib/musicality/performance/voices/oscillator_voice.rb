require 'musicality'

module Musicality

class OscillatorVoice
  
  attr_accessor :sample_rate, :wave_type
  include HashMake
  
  VALID_WAVE_TYPES = [
    "square",
    "triangle",
    "sawtooth",
    "sine"
  ]
  
  REQ_ARGS = [
    spec_arg(:sample_rate, Numeric, ->(a){ a > 0.0 } ),
    spec_arg(:wave_type, SettingProfile, ->(a){ VALID_WAVE_TYPES.include? a.start_value } )
  ]
  OPT_ARGS = []
  
  def initialize settings
    process_args settings
    
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
  
  def change_freq freq
    @oscillator.freq = freq
  end
  
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
