require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::ProbabilityMass do
  it 'should raise error if the given probability map doesn\'t add up to 1' do
    expect { ProbabilityMass.new(:a => 0.5, :b => 0.49999999) }.to raise_error
  end

  describe '#select_randomly' do
    it 'should select values according to their probability' do
      prob_map = {
        0 => 0.5,
        1 => 0.25,
        2 => 0.25,
        3 => 0
      }

      pm = ProbabilityMass.new(prob_map)

      results = { 0 => 0, 1 => 0, 2 => 0, 3 => 0 }
      N_TIMES = 1000
      N_TIMES.times do
        choice = pm.select_randomly
        results[choice] += 1
      end

      results.each do |value, times|
        perc = times / N_TIMES.to_f
        perc.should be_within(0.05).of(prob_map[value])
      end
    end
  end
end
