require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Musicality::Optimization::ParticleSwarm do
  it "should perform vector match for ideal vector of all 1's" do
    size = 20
    position_bounds = [0.0..1.0, 0.0..1.0]
    swarm = Optimization::ParticleSwarm.new size, position_bounds
    
    evaluator = ->(position) do
      error = 0.0
      position.each do |x|
        error += (1.0-x).abs
      end
      
      return error
    end
    
    mutator = ->(velocity) do
      for i in 0...velocity.count do
        velocity[i] += rand(-0.05..0.05)
        velocity[i] *= rand(0.99..1.01)
      end
    end

    weights = { :current_velocity => 0.7, :personal_best => 0.15, :global_best => 0.15, :velocity_magnitude => 0.7 }
    
    start = Time.now
    particles = swarm.optimize 20, weights, evaluator, 0.01
    elapsed = Time.now - start
    
    best = particles.sort.first
    best.fitness.should be_within(0.1).of(0.0)
    
    #puts "took #{elapsed} sec to get to fitness of #{best.fitness}"
  end
end
