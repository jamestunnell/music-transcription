module Musicality

# Contains all the information needed to create the instrument plugin, configure
# initial settings, and any settings changes.
#
# @author James Tunnell
class InstrumentConfig
  include Hashmake::HashMakeable

  attr_reader :plugin_name, :initial_settings, :setting_changes

  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :plugin_name => arg_spec(:reqd => true, :type => String),
    :initial_settings => arg_spec_hash(:reqd => false),
    :setting_changes => arg_spec_hash(:reqd => false, :type => Hash)
  }
  
  # A new instance of InstrumentConfig.
  # @param [Hash] args Hashed arguments. Required key is :plugin_name (String).
  #                    Optional key is :initial_settings and setting_changes.
  def initialize args={}
    hash_make InstrumentConfig::ARG_SPECS, args
    
    ##  replace plain values with immediate value changes
    #@initial_settings.each do |key,val|
    #  unless val.is_a?(ValueChange)
    #    @initial_settings[key] = Musicality::immediate_change(val)
    #  end
    #end
    
    # make sure offsets are in range
    @setting_changes.each do |offset, hash|
      check_offset offset
      
      # replace plain values with immediate value changes
      hash.each do |key, val|
        unless val.is_a?(ValueChange)
          hash[keys] = Musicality::immediate_change(val)
        end
      end
    end
  end
end

end
