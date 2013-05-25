require 'musicality'
require 'yaml'

include Musicality

hash = {
  :score => {
    :program => {
      :segments => [0...1.0]
    },
    :beats_per_minute_profile => { :start_value => 120.0 },
    :parts => {
      1 => {
        :notes => [
          { :duration => 0.125, :intervals => [ { :pitch => C3 } ] },
          { :duration => 0.125, :intervals => [ { :pitch => D3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => C3 } ] },
          { :duration => 0.50, :intervals => [ { :pitch => C3 }, { :pitch => E3 } ] },
        ]
      }
    }
  },
  :instrument_configs => {
    1 => {
      :plugin_name => 'synth_instr_3',
      :initial_settings => ["blend", "short attack", "long decay"]
    },
  }
}

arrangement = Arrangement.new hash

File.open("instrument_test.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end
