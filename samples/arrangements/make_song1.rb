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
          { :duration => 0.375, :intervals => [{ :pitch => C2 } ]},
          { :duration => 0.25, :intervals => [{ :pitch => Eb2 } ]},
          { :duration => 0.3125, :intervals => [{ :pitch => F2 } ]},
          { :duration => 0.0625, :intervals => [{ :pitch => Eb2 } ]},
          # 1.0
          { :duration => 0.125 },
          { :duration => 0.25, :intervals => [{ :pitch => C2 } ]},
          { :duration => 0.25, :intervals => [{ :pitch => Eb2 } ]},
          { :duration => 0.375 },
          # 2.0
          { :duration => 0.375, :intervals => [{ :pitch => C2 } ]},
          { :duration => 0.25, :intervals => [{ :pitch => Eb2 } ]},
          { :duration => 0.3125, :intervals => [{ :pitch => F2 } ]},
          { :duration => 0.0625, :intervals => [{ :pitch => Eb2 } ]},
          # 3.0
          { :duration => 0.125 },
          { :duration => 0.25, :intervals => [{ :pitch => C2 } ]},
          { :duration => 0.25, :intervals => [{ :pitch => Eb2 } ]},
        ]
      }, 
      2 => {
        :notes => [
          # 0.0
          { :duration => 0.125 },
          { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
          { :duration => 0.25, :intervals => [{ :pitch => C4 } ]},
          { :duration => 0.25, :intervals => [{ :pitch => A3 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => G3 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => F3 } ]},
          { :duration => 0.3125, :intervals => [{ :pitch => G3, :link => slur(F3) } ]},
          { :duration => 0.0625, :intervals => [{ :pitch => F3, :link => slur(E3) } ]},
          { :duration => 0.125, :intervals => [{ :pitch => E3 } ]},
          { :duration => 0.125 },
          # 2.0
          { :duration => 0.125 },
          { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => Bb3 } ]},
          { :duration => 0.25, :intervals => [{ :pitch => C4 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => A3 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => E4 } ]},
          { :duration => 0.125, :intervals => [{ :pitch => E4, :link => slur(D4) } ]},
          { :duration => 0.125, :intervals => [{ :pitch => D4, :link => slur(C4) } ]},
          { :duration => 0.125, :intervals => [{ :pitch => C4 } ]},
        ]
      }
    }
  },
  :instrument_configs => {
    1 => {
      :plugin_name => 'synth_instr_1',
      :settings => {
        "harmonic_0_partial" => 0,
        "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SAWTOOTH,
        "harmonic_0_amplitude" => 0.2,
      }
    },
    2 => {
      :plugin_name => 'synth_instr_1',
      :settings => {
        "harmonic_0_partial" => 0,
        "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SQUARE,
        "harmonic_0_amplitude" => 0.4,
      }
    },
  }
}

arrangement = Arrangement.new hash

File.open("song1.yml", "w") do |file|
  file.write arrangement.make_hash.to_yaml
end
