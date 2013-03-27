module Musicality

# Contains classes used by performer to specify performance
# instructions and associated information. A different class
# for each instruction.
module Instructions

# Stores information needed to start a note.
class On
  attr_reader :offset, :note
  def initialize offset, note, attack_time_max = 0.0
    @offset = offset
    @note = note
    @attack_time_max = attack_time_max
  end
end

# Stores information needed to end a note.
class Off
  attr_reader :offset
  def initialize offset
    @offset = offset
  end
end

# Stores information needed to change note pitch.
class ChangePitch
  attr_reader :offset, :pitch
  def initialize offset, pitch
    @offset = offset
    @pitch = pitch
  end
end

# Stores information needed to restart note attack.
class RestartAttack
  attr_reader :offset, :attack, :sustain, :attack_time_max
  def initialize offset, attack, sustain, attack_time_max = 0.0
    @offset = offset
    @attack = attack
    @sustain = sustain
    @attack_time_max = attack_time_max
  end
end

# Stores information needed to release a note.
class Release
  attr_reader :offset, :damping
  def initialize offset, damping
    @offset = offset
    @damping = damping
  end
end

end
end
