module Musicality

# Used to generate a triangle wave that oscillates linearly between -1 and +1.
class TriangleWave < Oscillator
  
  # constant used to compute the wave base on current phase.
  TWO_OVER_PI = 2.0 / Math::PI
  
  def initialize sample_rate
    super sample_rate
  end  

  # Produce one sample of the wave based on the current phase.
  def render_wave_at phase
	  (TWO_OVER_PI * phase).abs - 1.0
  end

end

end
