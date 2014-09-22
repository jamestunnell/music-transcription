module Music
module Transcription
  class ValueNotPositiveError < StandardError; end
  class ValueOutOfRangeError < StandardError; end
  class ValueNotZeroError < StandardError; end
  class NotPositiveIntegerError < StandardError; end
  class SegmentNotIncreasingError < StandardError; end
  class SegmentNegativeError < StandardError; end
end
end