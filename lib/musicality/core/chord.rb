module Musicality

class Chord
  attr_reader :notes, :arpeggiate
  
  def initialize args={}
    
    if args[:notes]
      raise ArgumentError, "args[:notes] is not an Array" if !args[:notes].is_a?(Array)
      
      if !args[:notes].empty?
        for i in 0...args[:notes].length do
          raise ArgumentError, "note #{args[:notes][i]} in args[:notes] is not a note" if !args[:notes][i].is_a?(Note)
          
          if i > 0
            raise ArgumentError, "length of note #{i} in #{args[:notes]} is not the same as length of first note." if args[:notes][i].duration != args[:notes][0].duration
          end
        end
      end      
    end
    
    @notes = args[:notes] || []
    @arpeggiate = args[:arpeggiate] || false
  end
end

end
