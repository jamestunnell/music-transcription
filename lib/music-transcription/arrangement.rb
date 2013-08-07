module Music
module Transcription

# Contains a Score object, and also instrument configurations to be assigned to
# score parts.
class Arrangement
  include Hashmake::HashMakeable
  
  # specifies which hashed args can be used for initialize.
  ARG_SPECS = {
    :score => arg_spec(:reqd => true, :type => Score),
    :instrument_configs => arg_spec_hash(:reqd => false, :type => InstrumentConfig),
  }

  attr_reader :score, :instrument_configs
  
  def initialize args
    hash_make args, Arrangement::ARG_SPECS
  end
  
  # Assign a new score.
  # @param [Score] score The new score.
  # @raise [ArgumentError] if score is not a Score.
  def score= score
    Arrangement::ARG_SPECS[:score].validate_value score
    @score = score
  end
end

end
end
