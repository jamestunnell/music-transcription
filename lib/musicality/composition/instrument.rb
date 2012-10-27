module Musicality

# Abstraction of a musical instrument.
#
# @author James Tunnell
# 
class Instrument

  attr_reader :class_name, :settings

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :class_name, :settings ]
  # default values for optional hashed arguments
  OPTIONAL_ARG_DEFAULTS = { :settings => {}, :class_name => "Musicality::SquareWave" }

  # A new instance of Instrument.
  # @param [Hash] options Options hash. Valid keys are :settings, and :class_name.
  #                       The :settings key can be used to specify instrument-
  #                       specific settings, which will be passed to the
  #                       instrument's class when it is instantiated. The 
  #                       :class_name key will specify a certain Musicality 
  #                       instrument class to use as the instrument.
  def initialize options = {}
    opts = OPTIONAL_ARG_DEFAULTS.merge options
    self.class_name = opts[:class_name]
    self.settings = opts[:settings]
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
