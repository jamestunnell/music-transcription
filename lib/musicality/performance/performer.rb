module Musicality

# The performer reads a part, and determines when to start and stop each note. 
# An instrument plugin is used to render note samples. The instrument plugin will
# be specified by the instrument_config.
# 
# @author James Tunnell
# 
class Performer

  attr_reader :instrument, :sample_rate, :max_attack_time, :instruction_sequences, :instructions_future, :instructions_past

  # A new instance of Performer.
  # @param [Part] part The part to be used during performance.
  # @param [PluginConfig] instrument_config The instrument plugin configuration to be used in rendering samples.
  # @param [Numeric] sample_rate The sample rate used in rendering samples.
  def initialize part, instrument_config, sample_rate, max_attack_time
    @sample_rate = sample_rate
    @max_attack_time = max_attack_time

    @loudness_computer = ValueComputer.new part.loudness_profile
    
    settings = { :sample_rate => @sample_rate }.merge(instrument_config.settings)
    plugin = PLUGINS.plugins[instrument_config.plugin_name.to_sym]
    @instrument = plugin.make_instrument(settings)
    
    part.note_sequences.each do |note_sequence|
      intermediate_sequences = IntermediateSequencer.make_intermediate_sequences_from_note_sequence note_sequence
      # TODO - refine_intermediate_sequences(intermediate_sequences)
      @instruction_sequences = make_instruction_sequences(intermediate_sequences)
    end
    
    # TODO - practice_record = practice_instrument()
    # TODO - rehearsed_instructions = rehease_part(practice_record)
    
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
    
    @instruction_sequences.each do |id, seq|
      if seq.first.offset >= offset
        @instructions_future[id] = seq
        @instructions_past[id] = []
      else
        @instructions_future[id] = []
        @instructions_past[id] = seq
      end
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
        if instruction.class == Instructions::On
          @instrument.note_on instruction.note, seq_id
        elsif instruction.class == Instructions::Off
          @instrument.note_off seq_id
        elsif instruction.class == Instructions::ChangePitch
          @instrument.note_change_pitch seq_id, instruction.pitch
        elsif instruction.class == Instructions::RestartAttack
          @instrument.note_restart_attack seq_id, instruction.attack, instruction.sustain
        elsif instruction.class == Instructions::Release
          @instrument.note_release instruction.damping
        else
          raise "Unsupported instruction class #{instruction.class} called for"
        end
      end
      
      @instructions_past[seq_id] += instructions
    end

    loudness = @loudness_computer.value_at counter
    raise ArgumentError, "loudness is not between 0.0 and 1.0" if !loudness.between?(0.0,1.0)
    
    sample = (loudness * @instrument.render_sample)
    
    #@effects.each do |effect|
    #  sample += effect.render_sample
    #end
    
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
  
  private

  def refine_intermediate_sequences intermediate_sequences
    
    prev_seq = nil
    # Second pass is to add a constraint to ON and RESTART_ATTACK commands
    intermediate_sequences.each do |cur_seq|
      
      cur_seq.each_index do |j|
        instr_hash = cur_seq[j]
        limits = []
        
        if instr_hash[:instruction] == Instructions::On ||
           instr_hash[:instruction] == Instructions::RestartAttack
          
          next_instr_hash = cur_seq[j + 1]
          dur = next_instr_hash[:offset] - instr_hash[:offset]
          limits << (0.3 * dur)
          
          if instr_hash[:instruction] == Instructions::On && prev_seq
            prev_instr_dur = prev_seq[-2][:offset] - prev_seq[-3][:offset]  # at -1 and -2 offset should be same, so go back to -3
            limits << (0.3 * prev_instr_dur)
          end
          
          if instr_hash[:instruction] == Instructions::RestartAttack
            prev_instr_dur = instr_hash[:offset] - cur_seq[j-2][:offset]  # at -1 should be a ChangePitch instr with same offset, so go back -2
            limits << (0.3 * prev_instr_dur)
          end
          
          instr_hash[:limit] = limits.min
        end
      end
      
      prev_seq = cur_seq
    end

    return instr_sequences
  end
  
  def make_instruction_sequences intermediate_sequences
    instruction_sequences = {}
    
    intermediate_sequences.each do |intermediate_sequence|
      instruction_sequence = []
      
      note = intermediate_sequence.start_note
      offset = intermediate_sequence.start_offset
      instruction_sequence.push Instructions::On.new(offset, note)
      
      intermediate_sequence.instructions.each do |instruction|
        if instruction[:class] == Instructions::RestartAttack
          note = instruction[:note]
          offset = instruction[:offset]
          instruction_sequence.push Instructions::RestartAttack.new(offset, note.attack, note.sustain)
        elsif instruction[:class] == Instructions::ChangePitch
          note = instruction[:note]
          offset = instruction[:offset]
          instruction_sequence.push Instructions::ChangePitch.new(offset, note.pitch)
        else
          raise ArgumentError, "unknown instruction class #{instruction[:instruction]}"
        end
      end
      
      offset = intermediate_sequence.end_offset
      instruction_sequence.push Instructions::Off.new(offset)
      
      id = UniqueToken.make_unique_sym(3)
      instruction_sequences[id] = instruction_sequence
    end
    
    return instruction_sequences
  end

end

end

