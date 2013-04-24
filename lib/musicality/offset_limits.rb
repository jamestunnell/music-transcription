module Musicality
  # the minimum offset allowed, inclusive. Corresponds to min Fixnum
  MIN_OFFSET = -(2 **(0.size * 8 - 2))
  # the maximum offset allowed, inclusive. Corresponds to max Fixnum
  MAX_OFFSET = (2 **(0.size * 8 - 2) - 2)

  def check_offset offset
    unless (MIN_OFFSET..MAX_OFFSET).include?(offset)
      raise ArgumentError, "offset #{offsets} is not in range #{MIN_OFFSET}..#{MAX_OFFSET}"
    end
  end
end
