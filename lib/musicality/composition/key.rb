module Musicality

class Key < PitchClassSet
  attr_reader :tonic

  # @param [Fixnum] tonic_pc The pitch class of the primary tone of the key.
  # @param [Enumerable] related_pcs Pitch classes of the chord that goes along with the tonic.
  def initialize tonic_pc, related_pcs = []
    @tonic = tonic_pc
    super([tonic_pc] + related_pcs)
  end

  def nearest_pc pitch_class
    interval_classes = {}
    each do |pc|
      interval_classes[pc] = IntervalClass.from_two_pitch_classes pc, pitch_class
    end
    interval_classes.min_by {|pc,inverval_class| inverval_class}
  end
end

end