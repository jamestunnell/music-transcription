require 'yaml'

module Music
module Transcription

class Part
  attr_reader :start_dynamic, :dynamic_changes, :notes
  
  def initialize start_dynamic, notes: [], dynamic_changes: {}
    @notes = notes
    @start_dynamic = start_dynamic
    @dynamic_changes = dynamic_changes
    
    d = self.duration
    badkeys = dynamic_changes.keys.select {|k| k < 0 || k > d }
    if badkeys.any?
      raise ArgumentError, "dynamic change outside 0..#{d}"
    end
  end
  
  def clone
    Marshal.load(Marshal.dump(self))
  end
  
  def ==(other)
    return (@notes == other.notes) &&
    (@start_dynamic == other.start_dynamic) &&
    (@dynamic_changes == other.dynamic_changes)
  end

  def duration
    return @notes.inject(0) { |sum, note| sum + note.duration }
  end
end

end
end
