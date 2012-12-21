module Musicality

# A specific command to be performed by a performer.
class Instruction
  
  attr_reader :type, :offset, :data
  
  ON = :note_instruction_on
  CHANGE_PITCH = :note_instruction_change_pitch
  RESTART_ATTACK = :note_instruction_restart_attack
  RELEASE = :note_instruction_release
  OFF = :note_instruction_off
  
  Instructions = [ ON, CHANGE_PITCH, RESTART_ATTACK, RELEASE, OFF ]
  
  def initialize type, offset, data = nil
    unless Instructions.include?(type)
      raise ArgumentError, "type #{type} is not one of #{Instructions.inspect}"
    end
    
    @type = type
    @offset = offset
    @data = data
  end
end

end
