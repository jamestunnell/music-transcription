module Music
module Transcription

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
    :type => arg_spec(:reqd => false, :type => Symbol, :default => IMMEDIATE, :validator => ->(a) { Transition::TYPES.include?(a)}),
    :abruptness => arg_spec(:reqd => false, :type => Numeric, :default => 0.5, :validator => ->(a){ a.between?(0,1) })
  }
  
  attr_reader :type, :duration, :abruptness
  
  def initialize args = {}
    hash_make args, Transition::ARG_SPECS
  end

  # Compare the equality of another Transition object.
  def == other
    return (@type == other.type) &&
    (@duration == other.duration) && 
    (@abruptness) == other.abruptness
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

  def abruptness= abruptness
    Transition::ARG_SPECS[:abruptness].validate_value abruptness
    @abruptness = abruptness
  end
end

module_function

# Create a Transition object with 0 duration and of IMMEDIATE type.
def immediate
  Transition.new(:duration => 0.0, :type => Transition::IMMEDIATE)
end


# Create a Transition object of IMMEDIATE type, with the given duration.
def linear duration
  Transition.new(:duration => duration, :type => Transition::LINEAR)
end


# Create a Transition object of SIGMOID type, with the given duration.
def sigmoid duration, abruptness = Transition::ARG_SPECS[:abruptness].default
  Transition.new(:duration => duration, :type => Transition::SIGMOID, :abruptness => abruptness)
end

end
end
