module Musicality

# Used to generate a sawtooth wave that ramps from from -1 to +1.
class SawtoothWave < Oscillator

  # constant used to compute the wave base on current phase.  
  ONE_OVER_PI = 1.0 / Math::PI
  
  def initialize sample_rate, freq = 1.0
    super sample_rate, freq
  end
  
  # Produce one sample of the wave based on the current phase.
  def render_wave_at phase
    phase * ONE_OVER_PI
  end

end

end
