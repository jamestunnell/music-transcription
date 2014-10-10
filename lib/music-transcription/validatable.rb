# assumes that @checks is defined as an array of no-arg lambdas, each
# lambda raising an error (with useful msg) when check fails
module Validatable
  attr_reader :errors
  
  def check_methods
    if instance_variable_defined?(:@check_methods)
      methods = instance_variable_get(:@check_methods)
    else
      methods = []
    end
    
    if self.class.class_variable_defined?(:@@check_methods)
      methods += self.class.class_variable_get(:@@check_methods)
    end
    
    return methods
  end
  
  def validate
    @errors = []
    
    
    check_methods.each do |check_method|
      begin
        send(check_method)
      rescue StandardError => e
        @errors.push e
      end
    end
    
    validatables.each do |v|
      @errors += v.validate
    end
    
    return @errors
  end
  
  def validatables
    []
  end
  
  def valid?
    self.validate
    @errors.empty?
  end
  
  def invalid?
    !self.valid?
  end
end
