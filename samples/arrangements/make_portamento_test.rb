require 'musicality'
require 'yaml'

include Musicality

hash = {
  :score => {
    :program => {
      :segments => [0...4.0]
    },
    :beats_per_minute_profile => { :start_value => 120.0 },
    :parts => {
      1 => {
        :loudness_profile => { :start_value => 0.5 },
        :notes => [
          { :duration => 0.75, :intervals => [ { :pitch => C3, :link => portamento(F3) } ] },
          { :duration => 0.75, :intervals => [ { :pitch => F3, :link => portamento(C3) } ] },
          { :duration => 0.5, :intervals => [ { :pitch => C3 } ] }
        ]
      }
    }
  }
}

arrangement = Arrangement.new hash

File.open("portamento_test.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end
