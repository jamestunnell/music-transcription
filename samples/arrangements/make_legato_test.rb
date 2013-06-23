require 'musicality'
require 'yaml'

include Musicality

hash = {
  :score => {
    :program => {
      :segments => [0...4.0]
    },
    :tempo_profile => { :start_value => tempo(120) },
    :parts => {
      1 => {
        :notes => [
          { :duration => 0.25, :intervals => [ { :pitch => C3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => D3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => E3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => F3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => E3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => D3 } ] },
          { :duration => 0.5, :intervals => [ { :pitch => C3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => C3, :link => legato(D3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => D3, :link => legato(E3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => E3, :link => legato(F3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => F3, :link => legato(E3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => E3, :link => legato(D3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => D3, :link => legato(C3) } ] },
          { :duration => 0.5, :intervals => [ { :pitch => C3 } ] },
        ]
      }
    }
  }
}

arrangement = Arrangement.new hash

File.open("legato_test.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end
