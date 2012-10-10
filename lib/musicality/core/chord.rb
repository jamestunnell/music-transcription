module Musicality

class Chord
  attr_reader :notes
  
  def initialize args={}
    @notes = args[:notes] || []
  end
end

end
