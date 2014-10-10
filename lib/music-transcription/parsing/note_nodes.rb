module Music
module Transcription
module Parsing
  class NoteNode < Treetop::Runtime::SyntaxNode
    def primitives env
      [ self.to_note ]
    end
  end
  
  class RestNoteNode < NoteNode
    def to_note    
      Music::Transcription::Note.new(duration.to_r)
    end
  end

  class MonophonicNoteNode < NoteNode
    def to_note
      pitches = [ pl.pitch.to_pitch ]
      
      links = {}
      unless pl.the_link.empty?
        links[pitches[0]] = pl.the_link.to_link
      end
      
      artic = Music::Transcription::Articulations::NORMAL
      unless art.empty?
        artic = art.to_articulation
      end
      
      accent_flag = acc.empty? ? false : true
      Music::Transcription::Note.new(duration.to_r,
        pitches, links: links, articulation: artic, accented: accent_flag)
    end
  end

  class PolyphonicNoteNode < NoteNode
    def to_note
      pitches = [ pl.pitch.to_pitch ]
      
      links = {}
      unless pl.the_link.empty?
        links[pitches[0]] = pl.the_link.to_link
      end
      
      more_pitches.elements.each do |mp|
        pitches.push mp.pl.pitch.to_pitch
        unless mp.pl.the_link.empty?
          links[pitches[-1]] = mp.pl.the_link.to_link
        end
      end
      
      artic = Music::Transcription::Articulations::NORMAL
      unless art.empty?
        artic = art.to_articulation
      end
      
      accent_flag = acc.empty? ? false : true
      Music::Transcription::Note.new(duration.to_r,
        pitches, links: links, articulation: artic, accented: accent_flag)
    end
  end
end
end
end