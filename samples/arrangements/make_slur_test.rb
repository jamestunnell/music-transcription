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
        :notes => [
          { :duration => 0.25, :intervals => [ { :pitch => C3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => D3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => E3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => F3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => E3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => D3 } ] },
          { :duration => 0.5, :intervals => [ { :pitch => C3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => C3, :link => slur(D3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => D3, :link => slur(E3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => E3, :link => slur(F3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => F3, :link => slur(E3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => E3, :link => slur(D3) } ] },
          { :duration => 0.25, :intervals => [ { :pitch => D3, :link => slur(C3) } ] },
          { :duration => 0.5, :intervals => [ { :pitch => C3 } ] },
        ]
      }
    }
  }
}

arrangement = Arrangement.new hash

File.open("slur_test.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end
