require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PitchClasses do
  describe '.nearest_pc' do
    it 'should return the nearest pitch class found in pitch_classes, according to interval class' do
      a = NormalForm.new([5,7,10])
      a.nearest_pc(4).should eq(5)
      a.nearest_pc(6).should eq(5)
      a.nearest_pc(7).should eq(7)
      a.nearest_pc(8).should eq(7)
      a.nearest_pc(9).should eq(10)
      a.nearest_pc(0).should eq(10)

      b = Key.new(0, [4,7])
      b.nearest_pc(0).should eq(0)
      b.nearest_pc(10).should eq(0)
      b.nearest_pc(11).should eq(0)
      b.nearest_pc(1).should eq(0)
      b.nearest_pc(2).should eq(0)
    end
  end

  describe '.delta_map' do
    it 'should return a hash of pitch classes to intervals, that can be used to reproduce the starting pitch_classes' do
      [
        { :a => NormalForm.new([4,7,11]), :b => [0,5,6,9] },
        { :a => NormalForm.new([2,6,9]), :b => [7,10,0] },
        { :a => NormalForm.new([0,5]), :b => [1,4,6,9] }
      ].each do |hash|
        a = hash[:a]
        b = hash[:b]
        delta_map = a.delta_map(b)
        delta_map.should be_a Hash
        delta_map.count.should eq(b.count)
        
        NormalForm.new(
          delta_map.map {|pc, interval| pc - interval }
        ).should eq(a)
      end

    end
  end
end