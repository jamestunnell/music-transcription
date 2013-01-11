require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Window do
  context 'triangle' do
    context 'odd size' do
      it 'should be 1.0 at center two samples' do
        w = Window.new 9, Window::WINDOW_TRIANGLE
        w.data[4].should be_within(0.01).of(1.0)
      end
    end
    
    context 'even size' do
      it 'should be 1.0 at center two samples' do
        w = Window.new 10, Window::WINDOW_TRIANGLE
        w.data[4].should be_within(0.01).of(1.0)
        w.data[5].should be_within(0.01).of(1.0)
      end
    end
  end
end
