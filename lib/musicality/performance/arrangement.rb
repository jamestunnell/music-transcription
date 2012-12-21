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
  # @param [Float] sample_rate The sample rate to use in making instrument and effect plugins.
  def initialize parts
    @start = parts.inject(parts.first.find_start) {|so_far, part| now = part.find_start; (now < so_far) ? now : so_far }
    @end = parts.inject(parts.first.find_end) {|so_far, part| now = part.find_end; (now > so_far) ? now : so_far }
    
    @arranged_parts = []
    parts.each do |part|
      @arranged_parts << ArrangedPart.new(part)
    end
  end
  
end
end
