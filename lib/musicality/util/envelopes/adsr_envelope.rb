module Musicality

# Utility class that extrapolates between min/max values.
class MinMax
  attr_reader :min, :max
  
  def initialize min, max
    raise ArgumentError, "min is not less than max" unless min < max
    @min = min
    @max = max
  end
  
  # Determine the value based on the given percent between min and max values.
  def by_percent percent
    raise ArgumentError, "percent is not between 0.0 and 1.0" unless percent.between?(0.0,1.0)
    @min + ((@max - @min) * percent)
  end
end

# Produce an envelope based on given attack rate, decay rate, sustain level, and
# damping rate.
#
# @author James Tunnell
class ADSREnvelope
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
    :attack_rate => arg_spec(:reqd => true, :type => Numeric),
    :decay_rate => arg_spec(:reqd => true, :type => Numeric),
    :sustain_level => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ a <= 1.0 }),
    :damping_rate => arg_spec(:reqd => true, :type => Numeric),
  }
  
  attr_reader :attack_rate, :decay_rate, :sustain_level, :damping_rate,
    :mode, :mode_elapsed, :envelope,
    :attack_time, :attack_per_sample,
    :decay_time, :decay_per_sample,
    :damping_per_sample

  # THe default state of the envelope generator, both before attack occurs, and after release finishes (reaches 0).
  ENV_MODE_INACTIVE = :envModeInactive
  # THe state of the envelope generator where envelope is increasing toward one.
  ENV_MODE_ATTACK = :envModeAttack
  # THe state of the envelope generator where envelope is decreasing toward the sustain level.
  ENV_MODE_DECAY = :envModeDecay
  # THe state of the envelope generator where envelope is not changing.
  ENV_MODE_SUSTAIN = :envModeSustain
  # THe state of the envelope generator where envelope is decreasing toward zero.
  ENV_MODE_RELEASE = :envModeRelease
  
  # A new instance of ADSREnvelope.
  #
  # @param [Hash] args Hashed arguments. Required keys are :sample_rate,
  #                    :attack_rate_range, :decay_rate_range,
  #                    :sustain_level_range, and :damping_rate_range
  def initialize args
    hash_make ADSREnvelope::ARG_SPECS, args
    @sample_period = 1.0 / @sample_rate
  end
  
  def attack_rate= attack_rate
    validate_arg ARG_SPECS[:attack_rate], attack_rate
    @attack_rate = attack_rate
  end

  def decay_rate= decay_rate
    validate_arg ARG_SPECS[:decay_rate], decay_rate
    @decay_rate = decay_rate
  end

  def sustain_level= sustain_level
    validate_arg ARG_SPECS[:sustain_level], sustain_level
    @sustain_level = sustain_level
  end
  
  def damping_rate= damping_rate
    validate_arg ARG_SPECS[:damping_rate], damping_rate
    @damping_rate = damping_rate
  end
  
  def reset
    @mode = ENV_MODE_INACTIVE
    @mode_elapsed = 0.0
    @envelope = 0.0

    @attack_time = 0.0
    @attack_per_sample = 0.0
    @decay_time = 0.0
    @decay_per_sample = 0.0
    @damping_per_sample = 0.0
  end

  # Start the envelope at the given level.
  def attack start_level = 0.0
   
    @mode = ENV_MODE_ATTACK
    @mode_elapsed = 0.0
    
    @envelope = start_level
    
    # compute attack time and rate
    attack_height = 1.0 - start_level
    @attack_time = attack_height / @attack_rate
    @attack_per_sample = @attack_rate.to_f / @sample_rate
    
    # compute deacy time and rate
    decay_height = 1.0 - @sustain_level
    @decay_time = decay_height / @decay_rate
    @decay_per_sample = @decay_rate.to_f / @sample_rate
  end
  
  # Release the envelope, dampening as given.
  def release
    @mode = ENV_MODE_RELEASE
    @mode_elapsed = 0.0
    
    # puts into decay mode forever to release the envelope
    @damping_per_sample = @damping_rate.to_f / @sample_rate
  end
  
  # Render a sample of the envelope.
  def render_sample
    raise "Call start or restart before rendering sample" unless @attack_time && @attack_per_sample && @decay_time && @decay_per_sample
    sample = @envelope
    
    case @mode
    when ENV_MODE_ATTACK
      @envelope += @attack_per_sample
      
      if @mode_elapsed > @attack_time
        @mode = ENV_MODE_DECAY
        @mode_elapsed = 0.0
      end
    when ENV_MODE_DECAY
      @envelope -= @decay_per_sample
      
      if @mode_elapsed > @decay_time
        @mode = ENV_MODE_SUSTAIN
        @mode_elapsed = 0.0
      end
    when ENV_MODE_SUSTAIN
      # do nothing
    when ENV_MODE_RELEASE
      @envelope -= @damping_per_sample
      
      if @envelope < 0.0
        @envelope = 0.0
        @mode = ENV_MODE_INACTIVE
        @mode_elapsed = 0.0 
      end
    end
    
    #make sure the envelope is bounded between 0.0 and 1.0
    if @envelope > 1.0
      @envelope = 1.0
    elsif @envelope < 0.0
      @envelope = 0.0
    end
    
    @mode_elapsed += @sample_period
    return sample
  end
end

end
