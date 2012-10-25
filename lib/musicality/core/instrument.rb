module Musicality

# Abstraction of a musical instrument.
#
# @author James Tunnell
# 
class Instrument

  attr_reader :class, :settings

  # A new instance of Instrument.
  # @param [Hash] args Hashed arguments. Either :class, :symbol, or :string must 
  #                    be specified. The :settings key can be used to specify 
  #                    instrument-specific settings, which will be passed to the
  #                    instrument's class when it is instantiated.
  def initialize args = {}
    
    if args.has_key? :class
      self.class = args[:class]
    elsif args.has_key? :symbol
      sym = args[:symbol]
      raise ArgumentError, "The Musicality module does not contain the constant #{sym}" if !Musicality.constants.include?(sym)
      self.class = Musicality.const_get sym
    elsif args.has_key? :string
      sym = args[:string].to_sym
      raise ArgumentError, "The Musicality module does not contain the constant #{sym}" if !Musicality.constants.include?(sym)
      self.class = Musicality.const_get sym
    else
      raise ArgumentError, "args does not have any of the keys :class, :symbol, or :string." 
    end
    
    options = {
      :settings => {}
    }.merge args
    
    self.settings = options[:settings]
  end
  
  # Set the instrument class.
  # @param [Class] clss The instrument class
  # @raise [ArgumentError] if clss is not a Class.
  def class= clss
    raise ArgumentError, "clss is not a Class" if !clss.is_a?(Class)
    @class = clss
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
