module Musicality

# A specific command to be performed by a performer.
class Instruction
  
  attr_reader :type, :offset, :data
  
  # Instruct performer to start a note. Data should be set to desired note.
  ON = :note_instruction_on
  # Instruct performer to stop a note. Data should be nil.
  CHANGE_PITCH = :note_instruction_change_pitch
  # Instruct performer to change note pitches. Data should be set to a note containing the desired pitches.
  RESTART_ATTACK = :note_instruction_restart_attack
  # Instruct performer to restart an attack. Data should be set to a note containing the desired attack and sustain values.
  RELEASE = :note_instruction_release
  # Instruct performer to stop a note. Data should be nil.
  OFF = :note_instruction_off
  
  # A list of the valid instructions.
  Instructions = [ ON, CHANGE_PITCH, RESTART_ATTACK, RELEASE, OFF ]
  
  # A new instance of Instruction.
  # @param [Symbol] type The type of instruction to be performed. See Instructions list for valid instructions.
  # @param [Float] offset The offset where the instruction should be eecuted.
  # @param [Symbol] data The data to be used in executing the instruction.
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
