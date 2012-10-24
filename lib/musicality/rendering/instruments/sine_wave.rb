module Musicality

class SineWave < Oscillator
  
  def initialize sample_rate
    super sample_rate
  end  

  def render_wave_at phase
    Math::sin phase
  end

end

end
