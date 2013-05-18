require 'spcore'

module Musicality
class ADSRMeasurement
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :signal => arg_spec(:reqd => true, :type => SPCore::Signal),
  }
  attr_reader :signal, :envelope, :attack_time, :attack_height, :decay_time, :sustain_time, :sustain_height, :release_time

  def initialize args
    hash_make ADSRMeasurement::ARG_SPECS, args
    @envelope = @signal.envelope
    
    #envelope_extrema = @envelope.extrema
    #sample_period = 1.0 / @signal.sample_rate
    
    #envelope_max = envelope_extrema.maxima.max_by {|sample_idx, value| value }
    #@attack_time = envelope_max[0] * sample_period
    #@attack_height = envelope_max[1]
    
    # TODO:
    #
    # 1. Find the most prominent part of the envelope (highest peak-like
    #    feature) using correlation. The center of this prominence is called
    #    attack peak. Time before attack peak is attack time. Value at attack
    #    peak is attack height.
    #
    # 2. Find the most stable part of the envelope, which occurs after the
    #    attack peak (again using correlation). This is sustain portion, 
    #    the mean value of which is the sustain height, and the duration of
    #    which is the sustain time. The period after sustain is release period.
    #
  end
end
end