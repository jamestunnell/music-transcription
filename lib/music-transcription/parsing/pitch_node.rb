module Music
module Transcription
module Parsing
  class PitchNode < Treetop::Runtime::SyntaxNode
    def to_pitch
      
      sem = pitch_letter.to_semitone
      unless mod.empty?
        sem += case mod.text_value
        when "#" then 1
        when "b" then -1
        end
      end
      oct = octn.text_value.to_i
      Music::Transcription::Pitch.new(semitone: sem, octave: oct)
    end
  end
end
end
end