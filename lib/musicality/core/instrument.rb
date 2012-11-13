module Musicality

# Abstraction of a musical instrument.
#
# @author James Tunnell
# 
class Instrument
  include HashMake
  attr_reader :class_name, :settings

  # required hash-args (for hash-makeable idiom)
  REQ_ARGS = [ ]
  # optional hash-args (for hash-makeable idiom)
  OPT_ARGS = [ spec_arg(:class_name, String, -> {"Musicality::SquareWave"} ) ,
               spec_arg(:settings, Hash, ->{ Hash.new }) ]

  # A new instance of Instrument.
  # @param [Hash] args Hashed args. Valid, optional keys are :settings, and :class_name.
  #                       The :settings key can be used to specify instrument-
  #                       specific settings, which will be passed to the
  #                       instrument's class when it is instantiated. The 
  #                       :class_name key will specify a certain Musicality 
  #                       instrument class to use as the instrument.
  def initialize args = {}
    process_args args
  end
  
  # Set the instrument class name. Used later to make an instance of the instrument.
  # @param [String] class_name The name of the dseired instrument class.
  # @raise [ArgumentError] if class_name is not a String.
  def class_name= class_name
    raise ArgumentError, "class_name is not a String" if !class_name.is_a?(String)
    @class_name = class_name
  end

  # Set the instrument-specific settings.
  # @param [Hash] settings A Hash that contains instrument-specific settings, 
  #                        which will be passed to the instrument's class when
  #                        it is instantiated.
  # @raise [ArgumentError] if settings is not a Hash.
  def settings= settings
    raise ArgumentError, "settings is not a Hash" if !settings.is_a?(Hash)
  	@settings = settings
  end
end

end
