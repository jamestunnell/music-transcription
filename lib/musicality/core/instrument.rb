module Musicality

# Abstraction of a musical instrument.
#
# @author James Tunnell
# 
class Instrument

  attr_reader :name, :options

  # A new instance of Instrument.
  # @param [Hash] options Optional arguments. Valid keys are :notes, 
  #               :note_sequences, :dynamics, and :instrument
  def initialize name = "default", options = {}
    self.name = name
    self.options = options
  end
  
  # Set the instrument name.
  # @param [String] name The instrument name (could be general or specific)
  # @raise [ArgumentError] if name is not a String.
  def name= name
    raise ArgumentError, "name is not a String" if !name.is_a?(String)
    @name = name
  end

  # Set the instrument options
  # @param [Hash] options A Hash that contains instrument-specific options.
  # @raise [ArgumentError] if options is not a Hash.
  def options= options
    raise ArgumentError, "options is not a Hash" if !options.is_a?(Hash)
  	@options = options
  end
end

end
