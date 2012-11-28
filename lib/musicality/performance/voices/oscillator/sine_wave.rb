module Musicality

# Used to generate a sine wave from -1 to +1.
class SineWave < Oscillator
  
  def initialize sample_rate, freq = 1.0
    super sample_rate, freq
  end
  
  # Produce one sample of the wave based on the current phase.
  def render_wave_at phase
    Math::sin phase
  end

end

end
