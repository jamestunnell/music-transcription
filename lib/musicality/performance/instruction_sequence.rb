module Musicality

# A set of instructions to be executed, that can be related together by using
# the id of the sequence. During initialization of the sequence, an ON
# instruction will be add to the list of instruction. Before using the instruciton
# sequence, #end should be called so an OFF instruction will be added. Other
# instruction can be added by calling #add. All instructions added with either
# #add or #end should have offsets greater than the initial ON instruciton.
class InstructionSequence
  attr_reader :instructions, :has_end, :id
  def initialize start_offset, start_note
    on = Instruction.new(Instruction::ON, start_offset, start_note)
    @instructions = [on]
    @has_end = false
    @id = UniqueToken.make_unique_sym(3)
  end
  
  # Add a new instruction. Should occur after the first (ON) instruction.
  def add instruction
    raise ArgumentError, "instruction is not an Instruction" unless instruction.is_a?(Instruction)
    raise ArgumentError, "instruction offset is not after ON instruction offset" unless instruction.offset > @instructions.first.offset
    
    @instructions << instruction
  end
  
  # End the sequence by adding an OFF instruction at the given offset (which should occur after all the existing instructions).
  def end end_offset
    @instructions.each do |instruction|
      raise ArgumentError, "end offset is not after #{instruction.type} instruction at #{instruction.offset}" unless end_offset > instruction.offset
    end
    @instructions << Instruction.new(Instruction::OFF, end_offset)
    @has_end = true
  end

end

end
