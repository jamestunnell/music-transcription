require 'spcore'

module Musicality
class ADSRMeasurement
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :signal => arg_spec(:reqd => true, :type => SPCore::Signal),
    :attack_peak_duration => arg_spec(:reqd => false, :type => Numeric, :default => 0.01, :validator => ->(a){ a > 0 }),
    :silence_threshold => arg_spec(:reqd => false, :type => Numeric, :default => 0.001, :validator => ->(a){ a > 0 }),
  }
  attr_reader :signal, :envelope, :attack_time, :attack_height, :decay_time, :sustain_time, :sustain_height, :release_time

  def initialize args
    hash_make args
    @envelope = @signal.envelope
    
    # 1. Find the most prominent part of the envelope (highest peak-like
    #    feature). The center of this prominence is called
    #    attack peak. Time before attack peak is attack time. Value at attack
    #    peak is attack height.

    attack_peak_idx = find_attack_peak_idx
    sample_period = 1.0 / @signal.sample_rate
    
    @attack_time = attack_peak_idx * sample_period
    @attack_height = @envelope[attack_peak_idx]
    
    #envelope_extrema = @envelope.extrema
    #envelope_max = envelope_extrema.maxima.max_by {|sample_idx, value| value }
    
    # 2. Find the mean value of the envelope during the time after the attack
    #    peak, and before envelopee goes to zero. This is sustain height.
    
    sustain_end_idx = find_sustain_end_idx attack_peak_idx
    sustain_period = @envelope[(attack_peak_idx + 1)..sustain_end_idx]
    @sustain_height = sustain_period.inject(0) { |s,x| s + x } / sustain_period.count
    @sustain_time = sustain_period.count * sample_period
  end
  
  private
  
  def find_attack_peak_idx
    peak_count = (@attack_peak_duration * @signal.sample_rate).to_i
    if peak_count > @envelope.size
      raise ArgumentError, "attack peak count #{peak_count} is longer than signal envelope"
    end
    
    max_range = nil
    max_sum = nil
    
    for i in (peak_count - 1)...@envelope.size
      start = (i - peak_count + 1)
      range = start..i
      subset = @envelope[range]
      
      sum = subset.inject(0){|s,x| s + x }
      
      if max_sum.nil? || sum > max_sum
        max_sum = sum
        max_range = range
      end
    end
    
    max_subset = @envelope[max_range]
    peak_idx = max_range.min + max_subset.index(max_subset.max)
    
    return peak_idx
  end
  
  def find_sustain_end_idx attack_peak_idx
    
    sustain_end_idx = @envelope.size - 1
    
    (@envelope.size - 1).downto(attack_peak_idx + 1) do |i|
      if @envelope[i] <= @silence_threshold
        sustain_end_idx = i
      end
    end
    
    return sustain_end_idx
  end
end
end