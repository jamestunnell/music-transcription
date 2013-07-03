module Musicality
# Describes how to transition from one value to another.
class Transition
  include Hashmake::HashMakeable
  
  IMMEDIATE = :transitionImmediate  # no transition really. Immediately change value.
  LINEAR = :transitionLinear  # transition in a linear fashion.
  SIGMOID = :transitionSigmoid  # transition smoothly
  TYPES = [ IMMEDIATE, LINEAR, SIGMOID ]  # the transitions which are valid and expected
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :duration => arg_spec(:reqd => false, :type => Numeric, :default => 0.0, :validator => ->(a){ a >= 0.0 } ),
    :type => arg_spec(:reqd => false, :type => Symbol, :default => IMMEDIATE, :validator => ->(a) { Transition::TYPES.include?(a)})
  }
  
  attr_reader :type, :duration
  
  def initialize args = {}
    hash_make args, Transition::ARG_SPECS
  end

  # Compare the equality of another Transition object.
  def == other
    return (@type == other.type) &&
    (@duration == other.duration)
  end
  
  # Change the transition duration.
  def duration= duration
    Transition::ARG_SPECS[:duration].validate_value duration
    @duration = duration
  end
  
  # Change the transition type.
  def type= type
    Transition::ARG_SPECS[:type].validate_value type
    @type = type
  end
end

# Create a Transition object with 0 duration and of IMMEDIATE type.
def self.immediate
  Transition.new(:duration => 0.0, :type => Transition::IMMEDIATE)
end

# Create a Transition object of IMMEDIATE type, with the given duration.
def self.linear duration
  Transition.new(:duration => duration, :type => Transition::LINEAR)
end

# Create a Transition object of SIGMOID type, with the given duration.
def self.sigmoid duration
  Transition.new(:duration => duration, :type => Transition::LINEAR)
end

end
