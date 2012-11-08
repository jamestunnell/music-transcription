module Musicality

# A generic oscillator base class, which can render a sample for any phase 
# between -PI and +PI.
#
# @author James Tunnell
class Oscillator
  attr_reader :pitches, :sample_rate
  
  # constant used to calculate the phase rate and also used to adjust phase when 
  # it goes beyond the allowed range of -PI to +PI.
  TWO_PI = Math::PI * 2.0
  
  # A new instance of Oscillator.
  # @param [Hash] args Should contain the :sample_rate key.
  # @raise [ArgumentError] if args does not have the :sample_rate key.
  def initialize args
    raise ArgumentError, "args does not have the :sample_rate key" if !args.has_key?(:sample_rate)
    @sample_rate = args[:sample_rate]
    @pitches = {}
  end
  
  # Prepare a pitch to be rendered (along with any other pitches) when 
  # render_sample is called. Computes the phase rate according to the pitch's
  # ratio (frequency, basically).
  # 
  # @param [Pitch] pitch The pitch to be played.
  def start_pitch pitch
    phase_rate = (pitch.freq * TWO_PI) / @sample_rate.to_f
    @pitches[pitch] = { :phase_rate => phase_rate, :phase => 0.0 }
  end

  # Remove a pitch from the list of those to be rendered when render_sample is 
  # called.
  # 
  # @param [Pitch] pitch The pitch to be removed.
  def end_pitch pitch
    @pitches.delete pitch
  end
  
  # Render a sample of all the pitches currently set to be played. Increments 
  # each pitch's current phase based on its phase rate.
  def render_sample loudness = 1.0
    sample = 0.0
    
    @pitches.each do |pitch, state|
      #keep phase between -PI and +PI
      while state[:phase] > Math::PI
        state[:phase] -= TWO_PI
      end
      
      sample += render_wave_at(state[:phase])
      state[:phase] += state[:phase_rate]
    end
    
    return sample * loudness
  end
  
  # Default implementation of render_wave_at, which just produces 0. This should
  # never be called beacuse it's expected that subclasses will override this.
  def render_wave_at phase
    0.0
  end
  
  # Stop playing all notes
  def release_all
    @pitches.clear
  end
end

end

