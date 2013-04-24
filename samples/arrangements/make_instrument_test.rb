require 'musicality'
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
      :initial_settings => {
        "harmonic_0_partial" => 0,
        "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SINE,
        "harmonic_0_amplitude" => 0.2,
        "harmonic_1_partial" => 1,
        "harmonic_1_wave_type" => SPCore::Oscillator::WAVE_SINE,
        "harmonic_1_amplitude" => 0.1,
        "harmonic_2_partial" => 2,
        "harmonic_2_wave_type" => SPCore::Oscillator::WAVE_SINE,
        "harmonic_2_amplitude" => 0.05,
      }
    },
  }
}

arrangement = Arrangement.new hash

File.open("instrument_test.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end
