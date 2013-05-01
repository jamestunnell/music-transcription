module Musicality
# Describes the information represented by a sample file (e.g. sample rate,
# instrument configuration, attack).
class SampleFile
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :file_name => arg_spec(:reqd => true, :type => String, :validator => ->(a){ a.length > 0 }),
    :sample_rate => arg_spec(:reqd => true, :type => Fixnum, :validator => ->(a){ a > 0 }),
    :duration_sec => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ a > 0 }),
    :pitch => arg_spec(:reqd => true, :type => Pitch),
    :attack => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ a.between?(0.0,1.0) }),
    :sustain => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ a.between?(0.0,1.0) }),
    :separation => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ a.between?(0.0,1.0) }),
  }
  
  attr_reader :sample_rate, :duration_sec, :pitch, :attack, :sustain, :separation
  attr_accessor :file_name
  
  def initialize args
    hash_make SampleFile::ARG_SPECS, args
  end  
end
end
