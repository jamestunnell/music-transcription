module Musicality

class FlatEnvelope
  def initialize settings
  end
  
  def restart attack, sustain
  end
  
  def render_sample
    1.0
  end
end

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
