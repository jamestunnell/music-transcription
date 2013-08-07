require 'spcore'

module Musicality
# Processes a group of pitch classes, and stores the normal form. The normal form
# is where pitch classes are ordered so the largest interval between pitch classes
# occurs between the last and first pitch class.
class NormalForm
  include Musicality::OrderedPitchClasses
  attr_reader :pitch_classes

  def initialize pitch_classes
    @pitch_classes = pitch_classes.map {|pc| pc.to_pc }.uniq.sort
    ics = interval_classes

    ((ics.index(ics.max) + 1) % ics.count).times do
      @pitch_classes.rotate!
    end
  end

  def to_key
    Key.new(first, self[1..-1])
  end
end
end
