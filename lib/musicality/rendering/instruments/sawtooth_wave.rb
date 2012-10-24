module Musicality

class SawtoothWave < Oscillator
  
  ONE_OVER_PI = 1.0 / Math::PI
  
  def initialize sample_rate
    super sample_rate
  end  

  def render_wave_at phase
    phase * ONE_OVER_PI
  end

end

end
