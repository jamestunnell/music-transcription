module Musicality

class SquareWave < Oscillator
  
  def initialize sample_rate
    super sample_rate
  end  

  def render_wave_at phase
    (phase >= 0.0) ? 1.0 : -1.0
  end

end

end
