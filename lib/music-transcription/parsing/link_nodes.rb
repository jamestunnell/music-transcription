module Music
module Transcription
module Parsing
  class LinkNode < Treetop::Runtime::SyntaxNode; end
    
  class SlurNode < LinkNode
    def to_link
      Music::Transcription::Link::Slur.new(target.to_pitch)
    end
  end

  class LegatoNode < LinkNode
    def to_link
      Music::Transcription::Link::Legato.new(target.to_pitch)
    end
  end

  class GlissandoNode < LinkNode
    def to_link
      Music::Transcription::Link::Glissando.new(target.to_pitch)
    end
  end
  
  class PortamentoNode < LinkNode
    def to_link
      Music::Transcription::Link::Portamento.new(target.to_pitch)
    end
  end
  
  class TieNode < LinkNode
    def to_link
      Music::Transcription::Link::Tie.new
    end
  end  
end
end
end