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
    hash_make Transition::ARG_SPECS, args
  end

  # Compare the equality of another ValueChange object.
  def == other
    return (@type == other.type) &&
    (@duration == other.duration)
  end
  
  # Change the transition duration.
  def duration= duration
    validate_arg Transition::ARG_SPECS[:duration], duration
    @duration = duration
  end
  
  # Change the transition type.
  def type= type
    validate_arg Transition::ARG_SPECS[:type], type
    @type = type
  end
end

# Create a Transition object with 0 duration and of IMMEDIATE type.
def immediate
  Transition.new(:duration => 0.0, :type => Transition::IMMEDIATE)
end

# Create a Transition object of IMMEDIATE type, with the given duration.
def linear duration
  Transition.new(:duration => duration, :type => Transition::LINEAR)
end

# Create a Transition object of SIGMOID type, with the given duration.
def sigmoid duration
  Transition.new(:duration => duration, :type => Transition::LINEAR)
end

end
