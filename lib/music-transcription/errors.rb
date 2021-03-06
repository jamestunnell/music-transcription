module Music
module Transcription
  class NonZeroError < StandardError; end
  class NegativeError < StandardError; end
  class NonPositiveError < StandardError; end
  class NonIntegerError < StandardError; end
  class NonRationalError < StandardError; end
  class NonIncreasingError < StandardError; end
  class NotValidError < StandardError; end
end
end