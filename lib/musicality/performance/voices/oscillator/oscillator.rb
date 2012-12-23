module Musicality

# A generic oscillator base class, which can render a sample for any phase 
# between -PI and +PI.
#
# @author James Tunnell
class Oscillator
  attr_reader :freq, :sample_rate
  
  # constant used to calculate the phase rate and also used to adjust phase when 
  # it goes beyond the allowed range of -PI to +PI.
  TWO_PI = Math::PI * 2.0
  
  # A new instance of Oscillator.
  # @raise [ArgumentError] if args does not have the :sample_rate key.
  def initialize sample_rate, freq = 1.0
    @sample_rate = sample_rate
    @phase = 0.0
    self.freq = freq
  end
  
  # Prepare the freq to be rendered when  render_sample is called. Computes the
  # phase rate according to the frequency.
  # 
  # @param [Pitch] freq The freq to be played.
  def freq= freq
    @phase_rate = (freq * TWO_PI) / @sample_rate.to_f
  end

  # Render a sample of the freq currently set to be played. Increments 
  # each pitch's current phase based on its phase rate.
  def render_sample
    while @phase > Math::PI
      @phase -= TWO_PI
    end
      
    sample = render_wave_at(@phase)
    @phase += @phase_rate
    
    return sample
  end
  
  # Default implementation of render_wave_at, which just produces 0. This should
  # never be called beacuse it's expected that subclasses will override this.
  def render_wave_at phase
    0.0
  end
  
end

end

