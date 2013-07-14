require 'spcore'

module Musicality

# The fundamental unit for performing notes.
class InstrumentKey
  include Hashmake::HashMakeable

  # defines how hashed args should be formed for initialization
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Fixnum),
    :inactivity_threshold => arg_spec(:reqd => false, :type => Float, :default => SPCore::Gain.db_to_linear(-100.0)),
    :inactivity_timeout_sec => arg_spec(:reqd => true, :type => Float),
    
    :pitch_range => arg_spec(:reqd => true, :type => Range, :validator => ->(a){ a.min.is_a?(Pitch) && a.max.is_a?(Pitch) }),
    :start_pitch => arg_spec(:reqd => true, :type => Pitch),
    
    :handler => arg_spec(:reqd => true, :validator => ->(handler){ 
      return handler.respond_to?(:on) &&
      handler.method(:on).arity == 3 &&
      handler.respond_to?(:off) &&
      handler.method(:off).arity == 0 &&
      handler.respond_to?(:release) &&
      handler.method(:release).arity == 1 &&
      handler.respond_to?(:restart) &&
      handler.method(:restart).arity == 3 &&
      handler.respond_to?(:adjust) &&
      handler.method(:adjust).arity == 1 &&
      handler.respond_to?(:render) &&
      handler.method(:render).arity == 1
    }),
  }
  
  attr_reader :inactivity_threshold, :inactivity_timeout_sec, :sample_rate, :pitch_range, :start_pitch, :current_pitch, :handler
  
  def initialize args
    hash_make args, InstrumentKey::ARG_SPECS
    check_pitch @start_pitch
    
    @max_inactivity_samples = @inactivity_timeout_sec * @sample_rate
    @current_inactivity_samples = 0
    @current_pitch = @start_pitch
    @active = false
  end
  
  # Return true if the key is active. Once activated (by calling #on), a key
  # will remain active until it produces output below the inactivity threshold
  # for duration of the inactivity timeout.
  def active?
    return @active
  end

  # Return true if the key has been released (by calling #release or #off).
  def released?
    return @released
  end

  # Activate the key (start playing the note).
  #
  # @param [Numeric] attack The intensity put into starting the note.
  # @param [Numeric] sustain The desired level of sustain after starting the note.
  # @param [Pitch] pitch The pitch to be used in playing the note.
  def on(attack, sustain, pitch = @current_pitch)
    @handler.on(attack,sustain,pitch)
    activate
  end

  # Deactivate the key (stop playing the note altogether and at once).
  def off
    @handler.off
    deactivate
  end

  # Restart a note that is already going.
  #
  # @param [Numeric] attack The intensity put into starting the note.
  # @param [Numeric] sustain The desired level of sustain after starting the note.
  # @param [Pitch] pitch The pitch to be used in playing the note.
  #
  # @raise [RuntimeError] if key is not active.
  def restart(attack, sustain, pitch = @current_pitch)
    unless active?
      raise "Restarting is not allowed unless key is active"
    end

    @handler.restart(attack, sustain, pitch)
    activate
  end

  # Adjust the pitch of a note that is already going.
  #
  # @param [Pitch] pitch The pitch to be used in playing the note.
  #
  # @raise [RuntimeError] if key is not active.   
  def adjust(pitch)
    unless active?
      raise "Adjsuting sustain is not allowed unless key is active"
    end
    
    check_pitch pitch
    @handler.adjust(pitch)
    @current_pitch = pitch
  end

  # Let the note die out according to the given damping rate.
  #
  # @param [Numeric] damping The damping rate to use in quieting the note.
  #
  # @raise [RuntimeError] if key is not active.
  def release(damping)
    unless active?
      raise "Releasing is not allowed unless key is active"
    end
    
    @handler.release(damping)
    @released = true
  end

  # Render the output of the note being played.
  #
  # @param [Fixnum] count The number of samples to render
  #
  # @raise [RuntimeError] if key is not active.
  def render count
    unless active?
      raise "Rendering is not allowed unless key is active"
    end
    
    samples = @handler.render(count)
    
    if released?
      samples.each do |sample|
        if sample < @inactivity_threshold
          @current_inactivity_samples += 1
        else
          @current_inactivity_samples = 0
        end
        
        if @current_inactivity_samples >= @max_inactivity_samples
          deactivate
        end
      end
    end
    
    return samples
  end
  
  # Make sure a pitch fits in the key's allowed range.
  def check_pitch pitch
    raise ArgumentError, "pitch is less than pitch range min" if pitch < @pitch_range.min
    raise ArgumentError, "pitch is more than pitch range max" if pitch > @pitch_range.max
  end
  
  private

  def activate
    @active = true
    @current_inactivity_samples = 0
    @released = false
  end
  
  def deactivate
    @active = false
    @current_inactivity_samples = 0
    @released = true
  end
end
end
