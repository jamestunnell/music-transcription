module Musicality

# Used to generate a square wave that alternates between -1 and +1 with a 50% 
# duty cycle.
#
# @author James Tunell
class SquareWave < Oscillator
  
  def initialize sample_rate
    super sample_rate
  end  
  
  # Produce one sample of the wave based on the current phase.
  def render_wave_at phase
    (phase >= 0.0) ? 1.0 : -1.0
  end

end

end
