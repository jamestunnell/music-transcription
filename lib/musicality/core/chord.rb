module Musicality

class Chord
  attr_reader :notes, :arpeggiate
  
  def initialize args={}
    
    if args[:notes]
      raise ArgumentError, "args[:notes] is not an Enumerable" if !args[:notes].is_a?(Enumerable)
      
      if !args[:notes].empty?
        duration = nil
        
        args[:notes].each do |note|
          raise ArgumentError, "#{note} in args[:notes] is not a Note" if !note.is_a?(Note)
          
          if duration.nil?
            duration = note.duration 
          else
            raise ArgumentError, "length of note #{note} in #{args[:notes]} is not the same as length of first note." if note.duration != duration
          end
        end
      end      
    end
    
    @notes = args[:notes] || []
    @arpeggiate = args[:arpeggiate] || false
  end
end

end
