module Musicality

# Abstraction of a musical triplet: a group of three notes of the same duration.
#
# @author James Tunnell
#
class Triplet < NoteGroup
  
  # A new instance of Triplet.
  # @param [Enumerable] notes Enumerable containing exactly three Note objects of the same duration.
  def initialize notes

    super notes
    
    raise ArgumentError, "notes does not have exactly three Note objects" if notes.count != 3
    
    duration = notes.first.duration
    notes.each do |note|
      raise ArgumentError, "duration of note #{note} in #{notes} is not the same as duration of first note." if note.duration != duration
    end
  end
end

end
