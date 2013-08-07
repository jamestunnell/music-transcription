module Music
module Transcription

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
    :initial_settings => arg_spec(:reqd => false, :default => ->(){ {} }, :validator => ->(a){ a.is_a?(String) || a.is_a?(Array) || a.is_a?(Hash)} ),
    :setting_changes => arg_spec_hash(:reqd => false, :type => Hash)
  }
  
  # A new instance of InstrumentConfig.
  # @param [Hash] args Hashed arguments. Required key is :plugin_name (String).
  #                    Optional key is :initial_settings and setting_changes.
  def initialize args={}
    hash_make args, InstrumentConfig::ARG_SPECS
    
    @setting_changes.each do |offset, hash|
      hash.each do |key, val|
        # replace plain values with immediate value changes
        unless val.is_a?(ValueChange)
          hash[keys] = immediate_change(val)
        end
      end
    end
  end
end

end
end
