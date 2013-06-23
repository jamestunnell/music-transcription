require 'musicality'
require 'yaml'

include Musicality

hash = {
  :score => {
    :program => {
      :segments => [0...4.0]
    },
    :tempo_profile => { :start_value => tempo(120,0.25) },
    :parts => {
      1 => {
        :loudness_profile => { :start_value => 0.5 },
        :notes => [
          { :duration => 0.75, :intervals => [ {:pitch => C3, :link => glissando(F3) } ]},
          { :duration => 0.75, :intervals => [ {:pitch => F3, :link => glissando(C3) } ]},
          { :duration => 0.5, :intervals => [ {:pitch => C3 } ]},
        ]
      }
    }
  }
}

arrangement = Arrangement.new hash

File.open("glissando_test.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end
