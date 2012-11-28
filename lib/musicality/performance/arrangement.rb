module Musicality
# Contains time-based parts, and a map of instruments to part IDs, and a map
# of effects to part IDs.
#
# @author James Tunnell
class Arrangement
  attr_reader :start, :end, :parts#, :instrument_map, :effect_map
  
  # New instance of Arrangement
  #
  # @param [Array] parts Array of time-based parts.
  # @param [Hash] instrument_map Maps instrument classes to part IDs.
  # @param [Hash] effect_map Maps effect classes to part IDs.
  def initialize parts#, instrument_map, effect_map
    raise ArgumentError, "parts is not an Array" unless parts.is_a?(Array)
    #raise ArgumentError, "instrument_map is not an Hash" unless instrument_map.is_a?(Hash)
    #raise ArgumentError, "effect_map is not an Hash" unless effect_map.is_a?(Hash)
    
    @parts = parts
    #@instrument_map = instrument_map
    #@effect_map = effect_map
    
    @start = parts.first.find_start
    @end = parts.first.find_end

    parts.each do |part|
      sop = part.find_start
      @start = sop if sop < @start
      
      eop = part.find_end
      @end = eop if eop > @end
    end
  end

end
end
