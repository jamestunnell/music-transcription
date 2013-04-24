require 'musicality'
require 'yaml'

include Musicality

hash = {
  :score => {
    :program => {
      :segments => [0...8.0]
    },
    :beats_per_minute_profile => { :start_value => 120.0 },
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
      :initial_settings => {
        "harmonic_0_partial" => 0,
        "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SQUARE,
        "harmonic_0_amplitude" => 0.2,
        "harmonic_1_partial" => 1,
        "harmonic_1_wave_type" => SPCore::Oscillator::WAVE_SINE,
        "harmonic_1_amplitude" => 0.1,
        "harmonic_2_partial" => 2,
        "harmonic_2_wave_type" => SPCore::Oscillator::WAVE_SAWTOOTH,
        "harmonic_2_amplitude" => 0.05,
      }
    },
  }
}

arrangement = Arrangement.new hash

File.open("missed_connection.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end
