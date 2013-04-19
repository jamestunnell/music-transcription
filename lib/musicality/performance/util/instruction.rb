module Musicality

# Contains classes used by performer to specify performance
# instructions and associated information. A different class
# for each instruction.
module Instructions

# Stores information needed to start a note.
class On
  attr_reader :offset, :attack, :sustain, :pitch
  def initialize offset, attack, sustain, pitch
    @offset = offset
    @attack = attack
    @sustain = sustain
    @pitch = pitch
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
class Adjust
  attr_reader :offset, :pitch
  def initialize offset, pitch
    @offset = offset
    @pitch = pitch
  end
end

# Stores information needed to restart note attack.
class Restart
  attr_reader :offset, :attack, :sustain, :pitch
  def initialize offset, attack, sustain, pitch
    @offset = offset
    @attack = attack
    @sustain = sustain
    @pitch = pitch
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
