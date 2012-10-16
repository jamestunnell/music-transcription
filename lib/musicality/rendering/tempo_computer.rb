module Musicality

class TempoComputer
  MIN_NOTE_OFFSET = 0.to_r
  MAX_NOTE_OFFSET = (2 **(0.size * 8 - 2) - 2)
  
  attr_reader :piecewise_function
  
  def initialize tempos
    raise ArgumentError, "no starting tempo (tempo at offset 0)" if tempos[0.to_r].nil?
    raise ArgumentError, "starting tempo cannot have a non-zero transition duration" if tempos[00.to_r].transition.duration != 0
    
    @piecewise_function = Musicality::PiecewiseFunction.new
    
    sorted_tempo_keys = tempos.keys.sort
    for i in 0...sorted_tempo_keys.count do
      note_offset = sorted_tempo_keys[i]
      tempo = tempos[sorted_tempo_keys[i]]
      notes_per_sec = (tempo.beats_per_minute / 60.to_r) * tempo.beat_duration

      add_to_piecewise_function note_offset, tempo, notes_per_sec
    end
  end
  
  def notes_per_second_at note_offset
    @piecewise_function.evaluate_at note_offset
  end

  private
  
  def add_to_piecewise_function note_offset, tempo, notes_per_sec
    raise RangeError, "tempo note offset is less than zero!" if note_offset < 0
    func = nil      
    
    if tempo.transition.duration == 0
      func = lambda {|note_offset| notes_per_sec }
    elsif tempo.transition.shape == Musicality::Transition::SHAPE_LINEAR
      b = @piecewise_function.evaluate_at note_offset
      m = (notes_per_sec - b) / tempo.transition.duration
      
      func = lambda do |x|
        raise RangeError, "#{x} is not in the domain" if x < note_offset
        
        if x < (note_offset + tempo.transition.duration)
          ((m * (x - note_offset)) + b).to_r
        else
          notes_per_sec
        end
      end
    elsif tempo.transition.shape == Musicality::Transition::SHAPE_SIGMOID
      raise NotImplementedError, "sigmoid transitions not implemented yet"
      #func = 
    end
    
    @piecewise_function.add_piece note_offset...(MAX_NOTE_OFFSET + 1), func
  end
end

end
