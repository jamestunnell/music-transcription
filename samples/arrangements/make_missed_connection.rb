require 'musicality'
require 'yaml'

include Musicality

hash = {
  :score => {
    :program => {
      :segments => [0...8.0]
    },
    :tempo_profile => { :start_value => tempo(120) },
    :parts => {
      "bass" => {
        :notes => [
          # 0.0
          { :duration => 0.25, :intervals => [ { :pitch => Eb2 } ] },
          { :duration => 0.25 },
          { :duration => 0.25, :intervals => [ { :pitch => Bb2 } ] },
          { :duration => 0.25 },
          { :duration => 0.25, :intervals => [ { :pitch => Eb2 } ] },
          { :duration => 0.125 },
          { :duration => 0.125, :intervals => [ { :pitch => B2 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => Bb2 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => Ab2 } ] },
          
          # 2.0
          { :duration => 0.25, :intervals => [ { :pitch => Eb2 } ] },
          { :duration => 0.25 },
          { :duration => 0.25, :intervals => [ { :pitch => Bb2 } ] },
          { :duration => 0.25 },
          { :duration => 0.25, :intervals => [ { :pitch => Eb2 } ] },
          { :duration => 0.125 },
          { :duration => 0.125, :intervals => [ { :pitch => B2 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => Bb2 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => Ab2 } ] },
  
          # 4.0
          { :duration => 0.25, :intervals => [ { :pitch => Bb2 } ] },
          { :duration => 0.125 },
          { :duration => 0.125, :intervals => [ { :pitch => F3, :link => tie(F3) } ] },
          { :duration => 0.5, :intervals => [ { :pitch => F3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => Bb2 } ] },
          { :duration => 0.125 },
          { :duration => 0.125, :intervals => [ { :pitch => F3, :link => tie(F3) } ] },
          { :duration => 0.5, :intervals => [ { :pitch => F3 } ] },
  
          # 6.0
          { :duration => 0.25, :intervals => [ { :pitch => B2 } ] },
          { :duration => 0.125 },
          { :duration => 0.125, :intervals => [ { :pitch => Gb3, :link => tie(Gb3) } ] },
          { :duration => 0.5, :intervals => [ { :pitch => Gb3 } ] },
          { :duration => 0.25, :intervals => [ { :pitch => B2 } ] },
          { :duration => 0.125 },
          { :duration => 0.125, :intervals => [ { :pitch => Gb3, :link => tie(Gb3) } ] },
          { :duration => 0.5, :intervals => [ { :pitch => Gb3 } ] },
          
          #8.0
        ]
      }
    }
  },
  :instrument_configs => {
    "bass" => {
      :plugin_name => 'synth_instr_3',
      :initial_settings => "blend"
    },
  }
}

arrangement = Arrangement.new hash

File.open("missed_connection.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end
