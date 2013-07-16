require 'set'

module Musicality

class Key
  include Musicality::OrderedPitchClasses
  attr_reader :tonic, :pitch_classes

  # @param [Fixnum] tonic_pc The pitch class of the primary tone of the key.
  # @param [Enumerable] related_pcs Pitch classes of the chord that goes along with the tonic.
  def initialize tonic_pc, related_pcs = []
    @tonic_pc = tonic_pc
    pcs = ([tonic_pc] + related_pcs).to_pcs
    @pitch_classes = Set.new(pcs)
  end

  def nearest_pc pitch_class
    interval_classes = {}
    @pitch_classes.each do |pc|
      interval_classes[pc] = IntervalClass.from_two_pitch_classes pc, pitch_class
    end
    interval_classes.min_by {|pc,inverval_class| inverval_class}
 end

  def to_prime_form
    PrimeForm.new(@pitch_classes)
  end

  def ==(other)
    return @tonic_pc == other.tonic_pc && 
           @pitch_classes == other.pitch_classes
  end
end

end