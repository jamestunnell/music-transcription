module Musicality

class Oscillator
  attr_reader :pitches, :sample_rate
  
  TWO_PI = Math::PI * 2.0
  
  def initialize sample_rate
    @sample_rate = sample_rate
    @pitches = {}
  end
  
  def start_pitch pitch
    phase_incr = (pitch.ratio * TWO_PI) / @sample_rate.to_f
    @pitches[pitch] = { :phase_incr => phase_incr, :phase => 0.0 }
  end
  
  def end_pitch pitch
    @pitches.delete pitch
  end
  
  def render_sample
    sample = 0.0
    
    @pitches.each do |pitch, state|
      #keep phase between -PI and +PI
      if state[:phase] > Math::PI
        state[:phase] -= TWO_PI
      end
      
      sample += render_wave_at(state[:phase])
      state[:phase] += state[:phase_incr]
    end
    
    return sample
  end
  
  def render_wave_at phase
    0.0
  end
  
end

end

