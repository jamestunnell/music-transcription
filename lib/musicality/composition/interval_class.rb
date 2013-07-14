module Musicality

class IntervalClass

  def self.from_two_pitch_classes a, b
    a = a.to_pc
    b = b.to_pc
    c = (a - b).to_pc
    d = (b - a).to_pc
    (c < d) ? c : d
  end
end

end
