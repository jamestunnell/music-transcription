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
  attr_reader :attack_rate_minmax, :decay_rate_minmax, :sustain_level_minmax, :damping_rate_minmax,
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
  # @param [Hash] settings Hashed arguments. Required keys are :sample_rate,
  #                        :attack_rate_min, :attack_rate_max, :decay_rate_min,
  #                        :decay_rate_max, :sustain_level_min, :sustain_level_max,
  #                        :damping_rate_min, and :damping_rate_max.
  def initialize settings
    raise ArgumentError, "settings does not have :sample_rate key" unless settings.has_key?(:sample_rate)
    @sample_rate = settings[:sample_rate]
    @sample_period = 1.0 / @sample_rate
    
    raise ArgumentError, "settings does not have :attack_rate_min key" unless settings.has_key?(:attack_rate_min)
    raise ArgumentError, "settings does not have :attack_rate_max key" unless settings.has_key?(:attack_rate_max)
    raise ArgumentError, "settings does not have :decay_rate_min key" unless settings.has_key?(:decay_rate_min)
    raise ArgumentError, "settings does not have :decay_rate_max key" unless settings.has_key?(:decay_rate_max)
    raise ArgumentError, "settings does not have :sustain_level_min key" unless settings.has_key?(:sustain_level_min)
    raise ArgumentError, "settings does not have :sustain_level_max key" unless settings.has_key?(:sustain_level_max)
    raise ArgumentError, "settings does not have :damping_rate_min key" unless settings.has_key?(:damping_rate_min)
    raise ArgumentError, "settings does not have :damping_rate_max key" unless settings.has_key?(:damping_rate_max)
    @attack_rate_minmax = MinMax.new settings[:attack_rate_min], settings[:attack_rate_max]
    @decay_rate_minmax = MinMax.new settings[:decay_rate_min], settings[:decay_rate_max]
    @sustain_level_minmax = MinMax.new settings[:sustain_level_min], settings[:sustain_level_max]
    @damping_rate_minmax = MinMax.new settings[:damping_rate_min], settings[:damping_rate_max]

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
  def attack attack, sustain, envelope_start = 0.0
    raise ArgumentError, "attack is not between 0.0 and 1.0" unless attack.between?(0.0, 1.0)
    raise ArgumentError, "sustain is not between 0.0 and 1.0" unless sustain.between?(0.0, 1.0)
    raise ArgumentError, "envelope_start is not between 0.0 and 1.0" unless envelope_start.between?(0.0, 1.0)
   
    @mode = ENV_MODE_ATTACK
    @mode_elapsed = 0.0
    
    @envelope = envelope_start
    
    # compute attack time and rate
    attack_height = 1.0 - envelope_start
    attack_rate = @attack_rate_minmax.by_percent(attack)
    @attack_time = attack_height / attack_rate
    @attack_per_sample = attack_rate / @sample_rate
    
    # compute deacy time and rate
    decay_height = 1.0 - @sustain_level_minmax.by_percent(sustain)
    decay_rate = @decay_rate_minmax.by_percent(1.0 - sustain)
    @decay_time = decay_height / decay_rate
    @decay_per_sample = decay_rate / @sample_rate
  end
  
  # Release the envelope, dampening as given.
  def release damping
    raise ArgumentError, "damping is not between 0.0 and 1.0" unless damping.between?(0.0, 1.0)

    @mode = ENV_MODE_RELEASE
    @mode_elapsed = 0.0
    
    # puts into decay mode forever to release the envelope
    damping_rate = @damping_rate_minmax.by_percent(damping)
    @damping_per_sample = damping_rate / @sample_rate
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

# Register the plugin with Musicality::PLUGINS registry
PLUGINS.register :adsr_envelope do
  self.author = "James Tunnell"
  self.version = "1.0.0"
  self.extends  = [:envelope]
  #requires []
  self.extension_points = []
  self.params = { :description => 'Makes a ADSR  envelope, where attack and decay time depend on attack and sustain settings.' }

  def make_envelope settings
    Musicality::ADSREnvelope.new settings
  end
end

end
