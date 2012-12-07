require 'pry'

module Musicality
# Contains some useful optimization code, like the ParticleSwarm optimizer.
module Optimization

# The basic unit of a particle swarm. Has position (represents position in
# solution space) and velocity (for updating position). Mostly just a container.
class Particle
  include Comparable
  attr_accessor :position, :fitness, :velocity, :best, :best_fitness
  
  # New instance of Particle.
  # @param [Vector] position Starting position. Represents position in solution space.
  # @param [Float] fitness  Fitness of the start position.
  # @param [Vector] velocity Where the particle is headed. Used to modify position.
  def initialize position, fitness, velocity
    @position = position
    @fitness = fitness
    @best = position
    @best_fitness = fitness
    @velocity = velocity
  end
  
  # Compare to another particle based on fitness
  def <=> other
    @fitness <=> other.fitness
  end
end

# A swarm of particles for optimizing a solution which is represented as a vector.
# Each particle has a position that represents a solution. Particles move around
# solution space according to conditions of: current velocity, personal best
# fitness, and global best fitness. These coinditions are weighted according to
# input parameters.
class ParticleSwarm  
  attr_reader :particles, :vector_size, :position_bounds
  
  # A new instance of ParticleSwarm.
  # @param [Fixnum] swarm_size Number of particles to create for the swarm.
  # @position_bounds [Array] position_bounds Array containing Range objects.
  #                                          The array's length determines the size
  #                                          of each particle's position vector.
  #                                          Each range object is used to bound
  #                                          the values for a position vector offset.
  def initialize swarm_size, position_bounds = []
    raise ArgumentError, "position_bounds.count is less than 1." if position_bounds.count < 1
    
    @position_bounds = position_bounds
    @particles = []
            
    # make particles, with random (bounded) positions and random velocity vectors
    swarm_size.times do
      position = Vector.new
      velocity = Vector.new
      @position_bounds.each do |bound|
        position << rand(bound)
        range = 0.1 * (bound.last - bound.first)
        velocity << rand(-range..range)
      end
      fitness = 0.0
      @particles << Particle.new(position, fitness, velocity)
    end

  end
  
  # Try to improve the solutions represente by particle positions.
  # @param [Fixnum] iterations The number of times to run optimization on the swarm.
  # @param [Hash] weights Hash of the weights used in 1) modifying current velocity and
  #                       2) determining effective velocity.
  #                       
  #                       The current velocity is modified every iteration using the
  #                       following relationship:
  #                       
  #                         velocity = (velocity * weights[:current_velocity]) +
  #                                    (velocity * weights[:current_velocity]) +
  #                                    (velocity * weights[:current_velocity])
  #
  #                       Then position is modified using current velocity in the
  #                       following relationship:
  #                       
  #                         position += (velocity * weights[:velocity_magnitude])
  #                       
  #                       So the weights used are :current_velocity, :personal_best,
  #                       :global_best, and :velocity_magnitude.
  #
  # @param [Proc] fitness_evaluator Returns the fitness (Float, smaller is better) of the given position vector.
  # @param [Proc] stopping_fitness Optional stopping condition.
  def optimize iterations, weights, fitness_evaluator, stopping_fitness = 0.0

    [:current_velocity, :personal_best, :global_best, :velocity_magnitude].each do |key|
      raise ArgumentError, "weights does not have #{key} key" unless weights.has_key?(key)
    end
    
    alpha = weights[:current_velocity]
    beta = weights[:personal_best]
    #gamma = weights[:informant_best]
    delta= weights[:global_best]
    epsilon = weights[:velocity_magnitude]
    
    @particles.each do |particle|
      fitness = fitness_evaluator.call(particle.position)
      particle.fitness = fitness
      particle.best_fitness = fitness
    end
    
    particle_iterations = 0
    iterations.times do |i|
      best = particles.sort.first # global best
      break if best.fitness <= stopping_fitness
      #puts "global best fitness so far is #{best.fitness} is at position = #{best.position.inspect}"
      
      particles.each do |particle|
        particle_iterations += 1
        v_a = particle.velocity * alpha
        v_b = (particle.best - particle.position) * beta
        #v_c = (particle.informant_best - particle.position) * gamma
        v_d = (best.position - particle.position) * delta
        particle.velocity = (v_a + v_b + v_d)
        #velocity_mutator.call(particle.velocity)
      end

      # mutate each particle according to its velocity vector
      particles.each do |particle|
        particle.position += (particle.velocity * epsilon)
        bound particle  # if velocity mutation moved the position out of bounds, fix it
        particle.fitness = fitness_evaluator.call(particle.position)
        
        if particle.fitness < particle.best_fitness
          particle.best = particle.position
          particle.best_fitness = particle.fitness
        end
      end

    end
    
    #best = particles.sort.first
    #puts "global best fitness so far is #{best.fitness} is at position = #{best.position.inspect}"
    #puts "particle iterations = #{particle_iterations}"
    
    return particles
  end
  
  private

  # keep particle position in bounds    
  def bound particle
    @position_bounds.count.times do |j|
      bounds = @position_bounds[j]
      
      if particle.position[j] > bounds.last
        particle.position[j] = bounds.last
      elsif particle.position[j] < bounds.first
        particle.position[j] = bounds.first
      end
    end
  end
end

end
end
