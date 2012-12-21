module Musicality

# The performer reads a part, and determines when to start and stop each note. 
# An instrument(s) is used to render note samples. The exact instrument class(es) will be
# specified by the part.
# 
# @author James Tunnell
# 
class Performer

  attr_reader :arranged_part, :sample_rate, :instruments, :effects, :instructions_future, :instructions_past

  # A new instance of Performer.
  # @param [ArrangedPart] arranged_part The part to be used during performance.
  # @param [Numeric] sample_rate The sample rate used in rendering samples.
  def initialize arranged_part, sample_rate
    @sample_rate = sample_rate
    @arranged_part = arranged_part

    @loudness_computer = ValueComputer.new @arranged_part.loudness_profile

    @instruments = []
    @arranged_part.instrument_plugins.each do |hash|
      settings = { :sample_rate => @sample_rate }.merge(hash[:settings])
      @instruments << hash[:plugin].make_instrument(settings)
    end

    @effects = []
    @arranged_part.effect_plugins.each do |hash|
      settings = { :sample_rate => @sample_rate }.merge(hash[:settings])
      @effects << hash[:plugin].make_instrument(settings)
    end
    
    @instructions_future = {}
    @instructions_past = {}
  end

  # Figure which notes will be played, starting at the given offset. Must 
  # be called before any calls to perform_sample.
  #
  # @param [Numeric] offset The offset to begin playing notes at.
  def prepare_performance_at offset = 0.0
    @instructions_future.clear
    @instructions_past.clear
    
    @arranged_part.instruction_sequences.each do |seq|
      @instructions_future[seq.id] = seq.instructions.select { |instr| instr.offset >= offset }
      @instructions_past[seq.id] = seq.instructions.select { |instr| instr.offset < offset }
    end
  end
  
  # Render an audio sample of the part at the current offset counter.
  # Start or end notes as needed.
  #
  # @param [Numeric] counter The offset to sample performance at.
  def perform_sample counter
    instructions_to_exec = {}
    
    @instructions_future.each do |seq_id, instrs|
      instructions_to_exec[seq_id] = instrs.select { |instr| instr.offset <= counter }
      instrs.keep_if { |instr| instr.offset > counter }
    end
    
    instructions_to_exec.each do |seq_id, instructions|
      instructions.each do |instruction|
        case instruction.type
        when Instruction::ON
          @instruments.each do |instrument|
            note = instruction.data
            instrument.note_on note, seq_id
          end
        when Instruction::OFF
          @instruments.each do |instrument|
            instrument.note_off seq_id
          end
        when Instruction::CHANGE_PITCH
          @instruments.each do |instrument|
            note = instruction.data
            instrument.note_change_pitches seq_id, note.pitches
          end
        when Instruction::RESTART_ATTACK
          @instruments.each do |instrument|
            note = instruction.data
            instrument.note_restart_attack seq_id, note.attack, note.sustain
          end
        when Instruction::RELEASE
          # TODO
        else
          raise "Unsupported instruction type #{instruction.type} called for"
        end
      end
      
      @instructions_past[seq_id] += instructions
    end

    loudness = @loudness_computer.value_at counter
    raise ArgumentError, "loudness is not between 0.0 and 1.0" if !loudness.between?(0.0,1.0)
    
    sample = 0.0
    
    @instruments.each do |instrument|
      sample += (loudness * instrument.render_sample)
    end
    
    @effects.each do |effect|
      sample += effect.render_sample
    end
    
    return sample
  end

  # Release any currently playing notes
  def release_all
    @instruments.each do |instrument|      
      instrument.notes.each do |id,note|
        instrument.release_note id
      end
    end
  end
end

end

