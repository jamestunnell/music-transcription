module Musicality
# Requires the pitch_classes method be defined.
module OrderedPitchClasses
  include PitchClasses

  # Calculates the interval classes between pitch classes.
  # @return [Array]
  def interval_classes
    interval_classes = []
    pcs = pitch_classes
    pcs.each_index do |i|
      pc_l = pcs[i]
      pc_r = pcs[(i+1) % pcs.count]
      interval_classes.push(IntervalClass.from_two_pitch_classes(pc_l, pc_r))
    end
    interval_classes
  end
end
end
