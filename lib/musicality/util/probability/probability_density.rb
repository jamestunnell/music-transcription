require 'spcore'

module Musicality

class ProbabilityDensity
  class IntervalNotInDomainError < StandardError; end
  class ValueNotPositiveError < StandardError; end

  attr_reader :function, :domain, :resolution
  def initialize function, domain, resolution
    @domain = domain
    @resolution = resolution

    sum = SPCore::Statistics.sum(
      @domain.step(@resolution).map do |x|
        y = function.call(x)
        raise ValueNotPositiveError unless y >= 0
        @resolution * y
      end
    )
    scale = (1.0 / sum)
    @function = ->(x){ function.call(x) * scale }
  end

  def probability_over_interval interval
    overlap = @domain & interval
    raise IntervalNotInDomainError if overlap.nil?
    SPCore::Statistics.sum(overlap.step(@resolution).map {|x| @resolution * @function.call(x) })
  end

  # Maps discrete values in the domain to probabilities.
  def discrete_probabilities
    map = {}

    @domain.step(resolution) do |x|
      n = x.to_i
      y = @function.call(x) * @resolution
      if map.has_key? n
        map[n] += y
      else
        map[n] = y
      end
    end

    sum = SPCore::Statistics.sum map.values
    if (1 - sum).abs > 0
      map[map.keys.last] += (1 - sum)
    end

    return map
  end

  def plot
    SPCore::Plotter.plot_functions(@domain, @resolution, "probability density" => @function)
  end
end

end