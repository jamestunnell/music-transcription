module Musicality
# Contains time-based parts, and a map of instruments to part IDs, and a map
# of effects to part IDs.
#
# @author James Tunnell
class Arrangement
  attr_reader :start, :end, :arranged_parts
  
  # New instance of Arrangement
  #
  # @param [Array] parts Array of collated, time-based, composed parts (i.e., score should pass through score collator and time converter first)
  def initialize parts, instrument_map
    @start = parts.values.inject(parts.values.first.find_start) {|so_far, part| now = part.find_start; (now < so_far) ? now : so_far }
    @end = parts.values.inject(parts.values.first.find_end) {|so_far, part| now = part.find_end; (now > so_far) ? now : so_far }
    
    @arranged_parts = []
    parts.each do |id, part|
      @arranged_parts << ArrangedPart.new(part, instrument_map[id])
    end
  end
  
end
end
