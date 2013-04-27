module Musicality

# The performer reads a part, and determines when to start and stop each note. 
# An instrument plugin is used to render note samples. The instrument plugin will
# be specified by the instrument_config.
# 
# @author James Tunnell
# 
class Performer

  attr_reader :part, :instrument, :max_attack_time, :instruction_sequences, :instructions_future, :instructions_past

  # A new instance of Performer.
  # @param [Part] part The part to be used during performance.
  # @param [Instrument] instrument The instrument to be used in rendering samples.
  # @param [Numeric] max_attack_time The maximum value to use when calculating attack time.
  def initialize part, instrument, max_attack_time
    @part = part
    @instrument = instrument
    @max_attack_time = max_attack_time
    @loudness_computer = ValueComputer.new part.loudness_profile
    
    note_sequences = Sequencer.extract_note_sequences part
    @instruction_sequences = {}
    note_sequences.each do |note_seq|
      id = UniqueToken.make_unique_sym(3)
      instructions = Sequencer.make_instructions note_seq
      @instruction_sequences[id] = instructions
    end
    
    # TODO - refine_intermediate_sequences(intermediate_sequences)
    
    #practice_record = practice_instrument()
    # TODO - rehearsed_instructions = rehease_part(practice_record)
    
    @instructions_future = {}
    @instructions_past = {}
    @key_assignments = {}
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
    
    @key_assignments.clear
  end
  
  # Render an audio sample of the part at the current offset counter.
  # Start or end notes as needed.
  #
  # @param [Numeric] counter The offset to sample performance at.
  def perform_samples counter, n_to_perform
    instructions_to_exec = {}
    
    @instructions_future.each do |seq_id, instrs|
      instructions_to_exec[seq_id] = instrs.select { |instr| instr.offset <= counter }
      instrs.keep_if { |instr| instr.offset > counter }
    end
    
    instructions_to_exec.each do |seq_id, instructions|
      instructions.each do |instruction|
        if instruction.class == Instructions::On
          key_id = @instrument.increase_polyphony
          
          @key_assignments[seq_id] = key_id
          @instrument.keys[key_id].on instruction.attack, instruction.sustain, instruction.pitch
        elsif instruction.class == Instructions::Off
          key_id = @key_assignments[seq_id]
          @instrument.keys[key_id].off
          @key_assignments.delete seq_id
          
          @instrument.decrease_polyphony key_id
        elsif instruction.class == Instructions::Adjust
          key_id = @key_assignments[seq_id]
          @instrument.keys[key_id].adjust instruction.pitch
        elsif instruction.class == Instructions::Restart
          key_id = @key_assignments[seq_id]
          @instrument.keys[key_id].restart instruction.attack, instruction.sustain
        elsif instruction.class == Instructions::Release
          key_id = @key_assignments[seq_id]
          @instrument.keys[key_id].release instruction.damping
        else
          raise "Unsupported instruction class #{instruction.class} called for"
        end
      end
      
      @instructions_past[seq_id] += instructions
    end

    loudness = @loudness_computer.value_at counter
    raise ArgumentError, "loudness is not between 0.0 and 1.0" if !loudness.between?(0.0,1.0)
    
    samples = @instrument.render(n_to_perform)
    samples = samples.map {|el| el * loudness }
    
    #@effects.each do |effect|
    #  sample += effect.render_sample
    #end
    
    return samples
  end

  # Release any currently playing notes
  def all_notes_off
    @instrument.notes.each do |id,note|
      instrument.note_off id
    end
  end

  ## Determine the attack time (time to reach max value) of a note.
  ## Start by silencing all currently playing notes, then play the
  ## entire note and keep track of where the maximum value occurs.
  #def find_note_attack_time note
  #  
  #  all_notes_off
  #  note_id = @instrument.note_on note
  #
  #  max_value = 0.0
  #  max_index = 0
  #
  #  (note.duration * @instrument.sample_rate).to_i.times do |i|
  #    sample = @instrument.render_sample
  #    
  #    if sample > max_value
  #      max_value = sample
  #      max_index = i
  #    end
  #  end
  #  @instrument.note_off note_id
  #  
  #  max_time = max_index.to_f / @instrument.sample_rate
  #  return max_time
  #end
  
  private
  
  def find_available_key
    # look through instrument keys for one that is not active
    avail_key = nil
    
    @keys.each do |key|
      unless key.active?
        avail_key = key
        break
      end
    end
    
    # if all keys are active, take over the oldest
    if avail_key.nil?
      
    end
  end
  
  #def refine_intermediate_sequences intermediate_sequences
  #  
  #  prev_seq = nil
  #  # Second pass is to add a constraint to ON and RESTART_ATTACK commands
  #  intermediate_sequences.each do |cur_seq|
  #    
  #    cur_seq.each_index do |j|
  #      instr_hash = cur_seq[j]
  #      limits = []
  #      
  #      if instr_hash[:instruction] == Instructions::On ||
  #         instr_hash[:instruction] == Instructions::Restart
  #        
  #        next_instr_hash = cur_seq[j + 1]
  #        dur = next_instr_hash[:offset] - instr_hash[:offset]
  #        limits << (0.3 * dur)
  #        
  #        if instr_hash[:instruction] == Instructions::On && prev_seq
  #          prev_instr_dur = prev_seq[-2][:offset] - prev_seq[-3][:offset]  # at -1 and -2 offset should be same, so go back to -3
  #          limits << (0.3 * prev_instr_dur)
  #        end
  #        
  #        if instr_hash[:instruction] == Instructions::Restart
  #          prev_instr_dur = instr_hash[:offset] - cur_seq[j-2][:offset]  # at -1 should be a Adjust instr with same offset, so go back -2
  #          limits << (0.3 * prev_instr_dur)
  #        end
  #        
  #        instr_hash[:limit] = limits.min
  #      end
  #    end
  #    
  #    prev_seq = cur_seq
  #  end
  #
  #  return instr_sequences
  #end
end

end

