module Musicality
# Processes a group of pitch classes, and stores the prime form. To obtain the
# prime form, the normal form and the normal form of the inverse are compared,
# and the more tightly packed to the left is kept and transposed to start at 0.
# The prime form algorithm is the original Forte version (as opposed to the 
# newer Rahn verison).
class PrimeForm
  include Musicality::OrderedPitchClasses
  attr_reader :pitch_classes

  def initialize pitch_classes
    normal = NormalForm.new pitch_classes
    normal_of_inverse = NormalForm.new pitch_classes.map {|pc| PitchClass.invert pc }
    
    a = normal.interval_classes
    b = normal_of_inverse.interval_classes
    normal_sum = 0
    normal_of_inverse_sum = 0
    pitch_classes_start = nil

    a.each_index do |i|
      normal_sum += a[i]
      normal_of_inverse_sum += b[i]

      if normal_sum < normal_of_inverse_sum
        pitch_classes_start = normal.pitch_classes
        break
      elsif normal_of_inverse_sum < normal_sum
        pitch_classes_start = normal_of_inverse.pitch_classes
        break
      end
    end

    if pitch_classes_start.nil?
      pitch_classes_start = normal.pitch_classes
    end

    @pitch_classes = pitch_classes_start.map {|pc| (pc - pitch_classes_start.first).to_pc }
  end

  def ==(other)
    return @pitch_classes == other.pitch_classes
  end
end
end
