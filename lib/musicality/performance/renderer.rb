module Musicality

# Renders an arrangement.
class Renderer
  
  # Render the given arrangement at the given sample rate.
  def self.render arrangement, sample_rate
    time_conversion_sample_rate = 250.0
    conductor = Musicality::Conductor.new arrangement, time_conversion_sample_rate, sample_rate
    
    unless block_given?
      puts "time   sample    "
    end
    
    samples = []
    conductor.perform do |sample|
      if block_given?
        yield sample
      else
        samples << sample

        if(samples.count % 10000 == 0)
          print "%.4f:" % conductor.time_counter
          print "%08d   " % conductor.sample_counter
          print "%.4f   " % samples.last
  
          active_keys = 0
          conductor.performers.each do |performer|  
            active_keys += performer.instrument.active_keys.count
          end
  
          print "#{active_keys} active keys"
          puts ""
        end
      end
    end
    
    return samples
  end
end

end
