module Musicality

class PitchRange
  attr_reader :left, :right
  def initialize left, right, include_left, include_right
    @left = left
    @right = right
    @include_left = include_left
    @include_right = include_right
  end
  
  def increasing?
    @right > @left
  end
  
  def decreasing?
    @right < @left
  end
  
  def include_left?
    @include_left
  end
  
  def include_right?
    @include_right
  end
  
  def exclude_left?
    !@include_left
  end
  
  def exclude_right?
    !@include_right
  end
  
  class Open < PitchRange
    def initialize left, right
      super(left, right, false, false)
    end
  end
      
  class Closed < PitchRange
    def initialize left, right
      super(left, right, true, true)
    end
  end
  
  class OpenLeft < PitchRange
    def initialize left, right
      super(left, right, false, true)
    end
  end
  
  class OpenRight < PitchRange
    def initialize left, right
      super(left, right, true, false)
    end
  end
end

end