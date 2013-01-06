module Musicality

# Contains classes used by performer to specify performance
# instructions and associated information. A different class
# for each instruction.
module Instructions
  
class On
  attr_reader :offset, :note
  def initialize offset, note, attack_time_max = 0.0
    @offset = offset
    @note = note
    @attack_time_max = attack_time_max
  end
end

class Off
  attr_reader :offset
  def initialize offset
    @offset = offset
  end
end

class ChangePitch
  attr_reader :offset, :pitch
  def initialize offset, pitch
    @offset = offset
    @pitch = pitch
  end
end

class RestartAttack
  attr_reader :offset, :attack, :sustain, :attack_time_max
  def initialize offset, attack, sustain, attack_time_max = 0.0
    @offset = offset
    @attack = attack
    @sustain = sustain
    @attack_time_max = attack_time_max
  end
end

class Release
  attr_reader :offset, :damping
  def initialize offset, damping
    @offset = offset
    @damping = damping
  end
end

end
end
