module Musicality
class OneVariableFunction
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :x_domain => arg_spec(:reqd => true, :type => Range),
    :proc => arg_spec(:reqd => true, :type => Proc, :validator => ->(a){a.arity == 1})
  }
  
  attr_reader :x_domain, :proc
  
  def initialize args
    hash_make args, OneVariableFunction::ARG_SPECS
  end
  
  def eval x
    unless @x_domain.include? x
      raise ArgumentError, "x domain #{@x_domain} does not include #{x}"
    end
    
    @proc.call(x)
  end
end
end