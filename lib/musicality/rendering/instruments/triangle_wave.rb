module Musicality

class TriangleWave < Oscillator
  
  TWO_OVER_PI = 2.0 / Math::PI
  
  def initialize sample_rate
    super sample_rate
  end  

  def render_wave_at phase
	  (TWO_OVER_PI * phase).abs - 1.0
  end

end

end
