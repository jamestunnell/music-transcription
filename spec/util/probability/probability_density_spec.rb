require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::ProbabilityDensity do
  it 'should raise error if any function values are not positive' do
    function = ->(x){ x > 0.5 ? -1 : 1 }
    expect { ProbabilityDensity.new(function, 0..1, 0.01) }.to raise_error
  end

  describe '#probability_over_interval' do
    it 'should integrate over the given interval' do
      function = ->(x){ 0.25 }
      pd = ProbabilityDensity.new(function, 0...4, 0.001)
      
      pd.probability_over_interval(0...1).should be_within(0.001).of(0.25)
      pd.probability_over_interval(1...2).should be_within(0.001).of(0.25)
      pd.probability_over_interval(3...4).should be_within(0.001).of(0.25)
      pd.probability_over_interval(0...2).should be_within(0.001).of(0.5)
      pd.probability_over_interval(0...4).should be_within(0.001).of(1)
    end
  end

  describe '#discrete_probabilities' do
    before :all do
      pd = ProbabilityDensity.new(->(x){ 1 }, 0...4, 0.001)
      @dp = pd.discrete_probabilities
    end
    
    it 'should produce a hash object' do
      @dp.should be_a(Hash)
    end

    it 'should produce a hash object whose values sum to 1' do
      SPCore::Statistics.sum(@dp.values).should eq(1.0)
    end
  end
end
