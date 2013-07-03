module Musicality
class TwoVariableFunction
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :x_domain => arg_spec(:reqd => true, :type => Range),
    :y_domain => arg_spec(:reqd => true, :type => Range),
    :proc => arg_spec(:reqd => true, :type => Proc, :validator => ->(a){a.arity == 2})
  }
  
  attr_reader :x_domain, :y_domain, :proc
  
  def initialize args
    hash_make args, TwoVariableFunction::ARG_SPECS
  end
  
  def eval x, y
    unless @x_domain.include? x
      raise ArgumentError, "x domain #{@x_domain} does not include #{x}"
    end

    unless @y_domain.include? y
      raise ArgumentError, "y domain #{@y_domain} does not include #{y}"
    end
    
    @proc.call(x,y)
  end
end
end