# Autogenerated from a Treetop grammar. Edits may be lost.


module Music
module Transcription
module Parsing

module Articulation
  include Treetop::Runtime

  def root
    @root ||= :articulation
  end

  def _nt_articulation
    start_index = index
    if node_cache[:articulation].has_key?(index)
      cached = node_cache[:articulation][index]
      if cached
        node_cache[:articulation][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_slur
    if r1
      r1 = SyntaxNode.new(input, (index-1)...index) if r1 == true
      r0 = r1
    else
      r2 = _nt_legato
      if r2
        r2 = SyntaxNode.new(input, (index-1)...index) if r2 == true
        r0 = r2
      else
        r3 = _nt_tenuto
        if r3
          r3 = SyntaxNode.new(input, (index-1)...index) if r3 == true
          r0 = r3
        else
          r4 = _nt_portato
          if r4
            r4 = SyntaxNode.new(input, (index-1)...index) if r4 == true
            r0 = r4
          else
            r5 = _nt_staccato
            if r5
              r5 = SyntaxNode.new(input, (index-1)...index) if r5 == true
              r0 = r5
            else
              r6 = _nt_staccatissimo
              if r6
                r6 = SyntaxNode.new(input, (index-1)...index) if r6 == true
                r0 = r6
              else
                @index = i0
                r0 = nil
              end
            end
          end
        end
      end
    end

    node_cache[:articulation][start_index] = r0

    r0
  end

  module Slur0
    def to_articulation
      Music::Transcription::Articulations::SLUR
    end
  end

  def _nt_slur
    start_index = index
    if node_cache[:slur].has_key?(index)
      cached = node_cache[:slur][index]
      if cached
        node_cache[:slur][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    if (match_len = has_terminal?("=", false, index))
      r0 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      r0.extend(Slur0)
      @index += match_len
    else
      terminal_parse_failure("=")
      r0 = nil
    end

    node_cache[:slur][start_index] = r0

    r0
  end

  module Legato0
    def to_articulation
      Music::Transcription::Articulations::LEGATO
    end
  end

  def _nt_legato
    start_index = index
    if node_cache[:legato].has_key?(index)
      cached = node_cache[:legato][index]
      if cached
        node_cache[:legato][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    if (match_len = has_terminal?("|", false, index))
      r0 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      r0.extend(Legato0)
      @index += match_len
    else
      terminal_parse_failure("|")
      r0 = nil
    end

    node_cache[:legato][start_index] = r0

    r0
  end

  module Tenuto0
    def to_articulation
      Music::Transcription::Articulations::TENUTO
    end
  end

  def _nt_tenuto
    start_index = index
    if node_cache[:tenuto].has_key?(index)
      cached = node_cache[:tenuto][index]
      if cached
        node_cache[:tenuto][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    if (match_len = has_terminal?("_", false, index))
      r0 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      r0.extend(Tenuto0)
      @index += match_len
    else
      terminal_parse_failure("_")
      r0 = nil
    end

    node_cache[:tenuto][start_index] = r0

    r0
  end

  module Portato0
    def to_articulation
      Music::Transcription::Articulations::PORTATO
    end
  end

  def _nt_portato
    start_index = index
    if node_cache[:portato].has_key?(index)
      cached = node_cache[:portato][index]
      if cached
        node_cache[:portato][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    if (match_len = has_terminal?("%", false, index))
      r0 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      r0.extend(Portato0)
      @index += match_len
    else
      terminal_parse_failure("%")
      r0 = nil
    end

    node_cache[:portato][start_index] = r0

    r0
  end

  module Staccato0
    def to_articulation
      Music::Transcription::Articulations::STACCATO
    end
  end

  def _nt_staccato
    start_index = index
    if node_cache[:staccato].has_key?(index)
      cached = node_cache[:staccato][index]
      if cached
        node_cache[:staccato][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    if (match_len = has_terminal?(".", false, index))
      r0 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      r0.extend(Staccato0)
      @index += match_len
    else
      terminal_parse_failure(".")
      r0 = nil
    end

    node_cache[:staccato][start_index] = r0

    r0
  end

  module Staccatissimo0
    def to_articulation
      Music::Transcription::Articulations::STACCATISSIMO
    end
  end

  def _nt_staccatissimo
    start_index = index
    if node_cache[:staccatissimo].has_key?(index)
      cached = node_cache[:staccatissimo][index]
      if cached
        node_cache[:staccatissimo][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    if (match_len = has_terminal?("'", false, index))
      r0 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      r0.extend(Staccatissimo0)
      @index += match_len
    else
      terminal_parse_failure("'")
      r0 = nil
    end

    node_cache[:staccatissimo][start_index] = r0

    r0
  end

end

class ArticulationParser < Treetop::Runtime::CompiledParser
  include Articulation
end


end
end
end