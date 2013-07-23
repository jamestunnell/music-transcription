require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::OneVariableFunction do
  describe '.new' do
    it 'should take as inputs an x-domain Range object, and the function callback' do
      cases = [
        { :x_domain => 0..10, :proc => ->(x){x**2} },
        { :x_domain => 4.1..60, :proc => ->(x){(x - 2)**2 + 3} },
      ]
      
      cases.each do |fn_params|
        fun = OneVariableFunction.new(fn_params)
        fun.x_domain.should eq(fn_params[:x_domain])
        fun.proc.should eq(fn_params[:proc])
      end
    end
  end
  
  describe '#eval' do
    before :all do
      @eval_cases = [
        {
          :function => OneVariableFunction.new(
            :x_domain => 0..10,
            :proc => ->(x){x**2},
          ),
          :value_map => { 1 => 1, 3 => 9, 5 => 25 },
          :bad_inputs => [-1,-0.1,10.1,20]
        }, {
          :function => OneVariableFunction.new(
            :x_domain => -50..50,
            :proc => ->(x){3*x + 5},
          ),
          :value_map => { 3 => 14, -10 => -25, 15 => 50},
          :bad_inputs => [-100, -50.001, 50.001]
        },
      ]
    end
    
    context 'input is in x domain' do
      it 'should produce results that match the value map' do
        @eval_cases.each do |eval_case|
          fn = eval_case[:function]
          eval_case[:value_map].each do |x,expected_y|
            y = fn.eval(x)
            y.should eq(expected_y)
          end
        end
      end
    end
    
    context 'input is not in x domain' do
      it 'should raise error' do
        @eval_cases.each do |eval_case|
          fn = eval_case[:function]
          eval_case[:bad_inputs].each do |x|
            lambda { fn.eval(x) }.should raise_error
          end
        end
      end
    end
  end
end
