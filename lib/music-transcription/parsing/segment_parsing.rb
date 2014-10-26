# Autogenerated from a Treetop grammar. Edits may be lost.


module Music
module Transcription
module Parsing

module Segment
  include Treetop::Runtime

  def root
    @root ||= :range
  end

  include NonnegativeInteger

  include NonnegativeFloat

  include NonnegativeRational

  module Range0
    def first
      elements[0]
    end

    def last
      elements[2]
    end
  end

  module Range1
    def to_range
      first.to_num...last.to_num
    end
  end

  def _nt_range
    start_index = index
    if node_cache[:range].has_key?(index)
      cached = node_cache[:range][index]
      if cached
        node_cache[:range][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_nonnegative_number
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?(@regexps[gr = '\A[.]'] ||= Regexp.new(gr), :regexp, index)
          r3 = true
          @index += 1
        else
          terminal_parse_failure('[.]')
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
        if s2.size == 3
          break
        end
      end
      if s2.size < 2
        @index = i2
        r2 = nil
      else
        r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      end
      s0 << r2
      if r2
        r4 = _nt_nonnegative_number
        s0 << r4
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Range0)
      r0.extend(Range1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:range][start_index] = r0

    r0
  end

  def _nt_nonnegative_number
    start_index = index
    if node_cache[:nonnegative_number].has_key?(index)
      cached = node_cache[:nonnegative_number][index]
      if cached
        node_cache[:nonnegative_number][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_nonnegative_float
    if r1
      r1 = SyntaxNode.new(input, (index-1)...index) if r1 == true
      r0 = r1
    else
      r2 = _nt_nonnegative_rational
      if r2
        r2 = SyntaxNode.new(input, (index-1)...index) if r2 == true
        r0 = r2
      else
        r3 = _nt_nonnegative_integer
        if r3
          r3 = SyntaxNode.new(input, (index-1)...index) if r3 == true
          r0 = r3
        else
          @index = i0
          r0 = nil
        end
      end
    end

    node_cache[:nonnegative_number][start_index] = r0

    r0
  end

end

class SegmentParser < Treetop::Runtime::CompiledParser
  include Segment
end


end
end
end