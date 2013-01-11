require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Signal do
  context '#cross_correlation' do
    it 'should return one-long array for f and g of equal size' do
      f = [ 5, 4, 3, 2, 1, 0 ]
      g = [ 0, 1, 2, 3, 4, 5 ]
      
      h = Musicality::Signal.new(f).cross_correlation g
      h.count.should eq(1)
    end

    it 'should return exactly array with only 0.0 when f and g of equal size and with equal contents' do
      #puts ""
      f = [ 5, 4, 3, 2, 1, 0 ]
      
      h = Musicality::Signal.new(f).cross_correlation f
      #puts "h #{h.inspect}"
      h.count.should eq(1)
      h[0].should eq(0.0)
    end
    
    it 'should detect correlation at the beginning' do
      #puts ""
      f = [ 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5 ]
      g = [ 5, 4, 3 ]
      
      h = Musicality::Signal.new(f).cross_correlation g
      #puts "h #{h.inspect}"
      h.index(h.min).should eq(0)
    end
    
    it 'should detect correlation in the middle' do
      #puts ""
      f = [ 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5 ]
      g = [ 1, 0, 1 ]
      
      h = Musicality::Signal.new(f).cross_correlation g
      #puts "h #{h.inspect}"
      h.index(h.min).should eq(4)
    end
    
    it 'should detect correlation at the end' do
      #puts ""
      
      f = [ 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5 ]
      g = [ 3, 4, 5 ]
      
      h = Musicality::Signal.new(f).cross_correlation g
      #puts "h #{h.inspect}"
      h.index(h.min).should eq(8)
    end
  end

end
