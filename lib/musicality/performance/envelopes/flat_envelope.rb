module Musicality

# Plain envelope that alsways produces 1.0 no matter what.
class FlatEnvelope
  # Set envelope to 0.
  def initialize settings
    @envelope = 0.0
  end
  
  # Set envelope to 1.
  def attack attack, sustain, envelope_start
    @envelope = 1.0
  end
  
  # Set envelope to 0.
  def release damping
    @envelope = 0.0
  end
  
  # Return envelope value.
  def render_sample
    @envelope
  end
end

# Register the plugin with Musicality::PLUGINS registry
PLUGINS.register :flat_envelope do
  self.author = "James Tunnell"
  self.version = "1.0.0"
  self.extends  = [:envelope]
  #requires []
  self.extension_points = []
  self.params = { :description => 'Makes a trivial constant 1.0 "envelope."' }

  def make_envelope settings
    Musicality::FlatEnvelope.new settings
  end
end

end
