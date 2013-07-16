module Musicality
# Processes a group of pitch classes, and stores the normal form. The normal form
# is where pitch classes are ordered so the largest interval between pitch classes
# occurs between the last and first pitch class.
class NormalForm
  include Musicality::OrderedPitchClasses
  attr_reader :pitch_classes

  def initialize pitch_classes
    @pitch_classes = pitch_classes.uniq.map {|pc| pc.to_pc }.sort
    ics = interval_classes

    ((ics.index(ics.max) + 1) % ics.count).times do
      @pitch_classes.rotate!
    end
  end

  def ==(other)
    return @pitch_classes == other.pitch_classes
  end
end
end
