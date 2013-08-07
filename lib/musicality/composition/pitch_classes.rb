module Musicality
# Requires the pitch_classes method be defined.
module PitchClasses
  include Enumerable

  def [](idx)
    pitch_classes[idx]
  end

  def &(other)
    pitch_classes & other.pitch_classes
  end

  def each
    pitch_classes.each do |pc|
      yield pc
    end
  end

  def == other
    pitch_classes == other.pitch_classes
  end

  def <=> other
    pitch_classes <=> other.pitch_classes
  end

  # Return the pitch classes nearest to the given pitch class.
  def nearest_pc other_pc
    min_by {|pc| IntervalClass.from_two_pitch_classes(pc, other_pc) }
  end

  # For each the given pitch_classes, find the nearest pitch class and then the 
  # pitch class interval between those pitch classes. Map the given pitch classes
  # to these intervals with a hash.
  def delta_map(other_pitch_classes)
    map = {}
    other_pitch_classes.each do |right_pc| 
      left_pc = nearest_pc(right_pc)
      ic = IntervalClass.from_two_pitch_classes(left_pc,right_pc)
      if(left_pc + ic).to_pc != right_pc
        ic *= -1
      end
      map[right_pc] = ic
    end
    return map
  end

end
end
