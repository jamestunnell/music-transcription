require 'spcore'

module Musicality

class ProbabilityMass
  class TotalProbabilityNotEqualToOne < StandardError
  end

  def initialize probability_map
    sum = SPCore::Statistics.sum probability_map.values
    raise TotalProbabilityNotEqualToOne if sum != 1
    @probability_map = probability_map
  end

  def select_randomly
    y = rand
    prob_so_far = 0
    @probability_map.each do |value,prob|
      prob_so_far += prob
      if y <= prob_so_far
        return value
      end
    end
  end

  def plot
    SPCore::Plotter.new(:linestyle => "impulses").plot_2d("probability mass function" => @probability_map)
  end
end

end
