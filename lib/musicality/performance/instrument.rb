require 'spnet'

module Musicality

# Base class to make an instrument that can be used by a Performer. Can make as
# many Key objbects as needed by performer, via increase_polyphony.
class Instrument
  include Hashmake::HashMakeable
 
  # defines how hashed args should be formed for initialization
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
    :key_maker => arg_spec(:reqd => true, :type => Proc, :validator => ->(a){ a.arity == 0 }),
    :params => arg_spec_hash(:reqd => false, :type => SPNet::ParamInPort),
  }
  
  attr_reader :keys, :sample_rate, :params
  
  def initialize args
    hash_make args, Instrument::ARG_SPECS
    @keys = {}
  end
  
  # Render samples using all of the active Key objbects.
  # @param [Fixnum] count The number of samples to render
  def render count
    samples = Array.new(count, 0)
    
    @keys.each do |id, key|
      if key.active?
        new_samples = key.render count
        
        count.times do |n|
          samples[n] += new_samples[n]
        end
      end
    end
    
    return samples
  end
  
  # Selects all the Key objbects that are active.
  def active_keys
    @keys.select {|id, key| key.active?}
  end

  # Selects all the Key objbects that are not active.
  def inactive_keys
    @keys.select {|id, key| !key.active?}
  end
  
  # Creates a new Key object, adding it to @keys.
  # @return [Symbol] the id for the new Key object.
  def increase_polyphony
    id = UniqueToken.make_unique_sym(3)
    @keys[id] = @key_maker.call()
    return id
  end

  # Removes the key indicated by the given id.
  # @param [Symbol] id Indicates which Key object to delete.
  def decrease_polyphony id
    @keys.delete id
  end
end
end