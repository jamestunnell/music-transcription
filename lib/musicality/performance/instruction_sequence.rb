module Musicality

class InstructionSequence
  attr_reader :instructions, :has_end, :id
  def initialize start_offset, start_note
    on = Instruction.new(Instruction::ON, start_offset, start_note)
    @instructions = [on]
    @has_end = false
    @id = UniqueToken.make_unique_sym(3)
  end
  
  def add instruction
    raise ArgumentError, "instruction is not an Instruction" unless instruction.is_a?(Instruction)
    raise ArgumentError, "instruction offset is not after ON instruction offset" unless instruction.offset > @instructions.first.offset
    
    @instructions << instruction
  end
  
  def end end_offset
    @instructions.each do |instruction|
      raise ArgumentError, "end offset is not after #{instruction.type} instruction at #{instruction.offset}" unless end_offset > instruction.offset
    end
    @instructions << Instruction.new(Instruction::OFF, end_offset)
    @has_end = true
  end

end

end
