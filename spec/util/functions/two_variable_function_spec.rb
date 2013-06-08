require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::TwoVariableFunction do
  describe '.new' do
    it 'should take as inputs an x and y domain Range object, and the function callback' do
      cases = [
        { :x_domain => 0..10, :y_domain => 0..10, :proc => ->(x, y){x**2 + y} },
        { :x_domain => 4.1..60, :y_domain => 1..5, :proc => ->(x, y){(x * y - 2)**2 + 3} },
      ]
      
      cases.each do |fn_params|
        fun = TwoVariableFunction.new(fn_params)
        fun.x_domain.should eq(fn_params[:x_domain])
        fun.y_domain.should eq(fn_params[:y_domain])
        fun.proc.should eq(fn_params[:proc])
      end
    end
  end
  
  describe '#eval' do
    before :all do
      @eval_cases = [
        {
          :function => TwoVariableFunction.new(
            :x_domain => 0..10,
            :y_domain => 2..4,
            :proc => ->(x,y){x**2 + y},
          ),
          :value_map => { [1,2] => 3, [3,3] => 12, [5,4] => 29 },
          :bad_x_inputs => [-1,-0.1,10.1,20],
          :bad_y_inputs => [1,0,6,22]
        },
        {
          :function => TwoVariableFunction.new(
            :x_domain => -50..50,
            :y_domain => -100..100,
            :proc => ->(x, y){3*x*y + 5},
          ),
          :value_map => { [3,10] => 95, [-10,-10] => 305, [15,1] => 50},
          :bad_x_inputs => [-100, -50.001, 50.001, 150],
          :bad_y_inputs => [-200, -100.1, 100.1, 150]
        },
      ]
    end
    
    context 'x input is x domain and y input is in y domain' do
      it 'should produce results that match the value map' do
        @eval_cases.each do |eval_case|
          fn = eval_case[:function]
          eval_case[:value_map].each do |inputs,expected_out|
            z = fn.eval(inputs[0], inputs[1])
            z.should eq(expected_out)
          end
        end
      end
    end
    
    context 'input is not in x domain' do
      it 'should throw ArgumentError' do
        @eval_cases.each do |eval_case|
          fn = eval_case[:function]
          y = fn.y_domain.min
          
          eval_case[:bad_x_inputs].each do |x|
            lambda { fn.eval(x,y) }.should raise_error(ArgumentError)
          end
        end
      end
    end
    
    context 'input is not in y domain' do
      it 'should throw ArgumentError' do
        @eval_cases.each do |eval_case|
          fn = eval_case[:function]
          x = fn.x_domain.min
          
          eval_case[:bad_y_inputs].each do |y|
            lambda { fn.eval(x,y) }.should raise_error(ArgumentError)
          end
        end
      end
    end
  end
end