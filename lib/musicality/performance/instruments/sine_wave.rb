module Musicality

# Used to generate a sine wave from -1 to +1.
class SineWave < Oscillator
  
  def initialize sample_rate
    super sample_rate
  end  

  # Produce one sample of the wave based on the current phase.
  def render_wave_at phase
    Math::sin phase
  end

end

end
