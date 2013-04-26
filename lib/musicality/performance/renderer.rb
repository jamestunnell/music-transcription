module Musicality

# Renders an arrangement.
class Renderer
  
  # Render the given arrangement at the given sample rate.
  def self.render arrangement, sample_rate, chunk_size, verbose = false
    time_conversion_sample_rate = 250
    conductor = Musicality::Conductor.new(
      :arrangement => arrangement,
      :time_conversion_sample_rate => time_conversion_sample_rate,
      :rendering_sample_rate => sample_rate
    )
    
    if verbose
      puts "time   sample   avg    active keys"
    end
    
    samples = []
    while conductor.time_counter < conductor.end_of_score
      conductor.perform_samples chunk_size do |new_samples|
        if block_given?
          yield new_samples, conductor
        else
          samples += new_samples
        end
        
        if verbose
          avg = new_samples.inject(0){|sum,a| sum + a } / new_samples.count
          keys = conductor.performers.inject(0){|active_keys, performer| active_keys + performer.instrument.active_keys.count }
          
          print "%.4f " % conductor.time_counter
          print "%08d " % conductor.sample_counter
          print "%.4f " % avg
          puts keys
        end
      end
    end
    
    return samples
  end
end

end
