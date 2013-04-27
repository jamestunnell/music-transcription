require 'musicality'
require 'yaml'

include Musicality

hash = {
  :score => {
    :program => {
      :segments => [
        0...4.0,
        0...4.0  
      ]
    },
    :beats_per_minute_profile => { :start_value => 120.0 },
    :parts => {
      1 => {
        :notes => [
          { :duration => 1.0, :intervals => [ {:pitch => C4} ]},
          { :duration => 1.0, :intervals => [ {:pitch => Bb3} ]},
          { :duration => 1.0, :intervals => [ {:pitch => Ab3} ]},
          { :duration => 0.5, :intervals => [ {:pitch => G3} ]},
          { :duration => 0.5, :intervals => [ {:pitch => Bb3} ]},
        ]
      }, 
      2 => { 
        :notes => [
          { :duration => 0.375, :intervals => [ {:pitch => E5 } ]},
          { :duration => 1.0, :intervals => [ {:pitch => D5 }]},
          { :duration => 1.0, :intervals => [ {:pitch => C5 }]},
          { :duration => 0.625, :intervals => [ {:pitch => C5 }]},
          { :duration => 0.5, :intervals => [ {:pitch => C5 }]},
          { :duration => 0.5, :intervals => [ {:pitch => D5 }]}
        ]
      },
      3 => {
        :notes => [
          { :duration => 0.125 },
          { :duration => 0.25, :intervals => [{:pitch => G5 }]},
          { :duration => 0.5, :intervals => [{:pitch => F5 }]},
          { :duration => 0.25 },
          { :duration => 0.25, :intervals => [{:pitch => F5 }]},
          { :duration => 0.5, :intervals => [{:pitch => Eb5 }]},
          { :duration => 0.25 },
          { :duration => 0.25, :intervals => [{:pitch => Eb5 }]},
          { :duration => 0.5, :intervals => [{:pitch => Eb5 }]},
          { :duration => 0.125 },
          { :duration => 0.5, :intervals => [{:pitch => Eb5 }]},
          { :duration => 0.5, :intervals => [{:pitch => F5 }]},
        ]
      }
    }
  },
  :instrument_configs => {
    1 => {
      :plugin_name => 'synth_instr_3',
      :initial_settings => "blend"
    },
    2 => {
      :plugin_name => 'synth_instr_3',
      :initial_settings => "blend"
    },
    3 => {
      :plugin_name => 'synth_instr_3',
      :initial_settings => "blend"
    }
  }
}

arrangement = Arrangement.new hash

File.open("song2.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end

