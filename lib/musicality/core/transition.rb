module Musicality

# Transition between values.
#
# @author James Tunnell
# 
# @!attribute [rw] duration
#   @return [Rational] The transition duration (in note length).
#
# @!attribute [rw] shape
#   @return [Symbol] The transition shape (e.g. linear, sigmoid)
#
class Transition

  # a simple linear transition
  SHAPE_LINEAR = :transitionLinear
  # a smooth natural 'S' transition
  SHAPE_SIGMOID = :transitionSigmoid

  #known transition shapes
  VALID_SHAPES = 
  [
    SHAPE_LINEAR,
    SHAPE_SIGMOID
  ]

  attr_reader :duration, :shape
  
  # A new instance of Transition.
  # @param [Rational] duration The transition duration (in note length).
  # @param [Symbol] shape The transition shape (e.g. linear, sigmoid). See 
  #                       VALID_SHAPES for known types). Linear by default.
  def initialize duration, shape = SHAPE_LINEAR
    self.duration = duration
    self.shape = shape
  end
  
  # Set the transition duration.
  # @param [Numeric] duration The transition duration (in note length).
  # @raise [ArgumentError] if duration is not a Rational and does not respond to :to_r
  # @raise [RangeError] if duration is less than zero.
  def duration= duration
    if !duration.is_a?(Rational)
  	  raise ArgumentError, "duration is not a Rational and does not respond to :to_r" if !duration.respond_to?(:to_r)
  	  duration = duration.to_r
  	end

  	raise RangeError, "duration is less than 0." if duration < 0
  	@duration = duration
  end

  # Set the transition shape.
  # @param [Symbol] shape The transition shape (e.g. linear, sigmoid)
  # @raise [ArgumentError] if shape is not know (one of VALID_SHAPES)
  def shape= shape
	  raise ArgumentError, "shape is not known (not on of #{VALID_SHAPES.inspect}" if !VALID_SHAPES.include?(shape)
  	@shape = shape
  end

end

end

