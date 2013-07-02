require 'musicality'
require 'yaml'

include Musicality

bass_notes = [
  # 0.0
  { :duration => Rational(1,6), :intervals => [{:pitch => "Bb2".to_pitch}]},
  { :duration => Rational(1,4) },
  { :duration => Rational(1,3), :intervals => [{:pitch => "Ab2".to_pitch}]},
  { :duration => Rational(1,6), :intervals => [{:pitch => "F2".to_pitch}]},
  { :duration => Rational(1,12), :intervals => [{:pitch => "Ab2".to_pitch}]},
  # 1.0
  { :duration => Rational(1,6), :intervals => [{:pitch => "Bb2".to_pitch}]},
  { :duration => Rational(1,4) },
  { :duration => Rational(1,3), :intervals => [{:pitch => "Ab2".to_pitch}]},
  { :duration => Rational(1,4), :intervals => [{:pitch => "Ab2".to_pitch}]},
  # 2.0
  { :duration => Rational(1,6), :intervals => [{:pitch => "C3".to_pitch}]},
  { :duration => Rational(1,4) },
  { :duration => Rational(1,3), :intervals => [{:pitch => "Bb2".to_pitch}]},
  { :duration => Rational(1,6), :intervals => [{:pitch => "G2".to_pitch}]},
  { :duration => Rational(1,12), :intervals => [{:pitch => "Bb2".to_pitch}]},
  # 3.0
  { :duration => Rational(1,6), :intervals => [{:pitch => "C3".to_pitch}]},
  { :duration => Rational(1,4) },
  { :duration => Rational(1,3), :intervals => [{:pitch => "Bb2".to_pitch}]},
  { :duration => Rational(1,4), :intervals => [{:pitch => "Bb2".to_pitch}]},
]

lead_notes = [
  
  # 0.0
  { :duration => Rational(1,6), :intervals => [{:pitch => "Bb3".to_pitch}]},
  { :duration => Rational(1,4)},
  { :duration => Rational(1,12), :intervals => [{:pitch => "Db4".to_pitch, :link => tie("Db4".to_pitch)}]},
  { :duration => Rational(1,6), :intervals => [{:pitch => "Db4".to_pitch, :link => tie("Db4".to_pitch)}]},
  { :duration => Rational(1,36), :intervals => [{:pitch => "Db4".to_pitch}]},
  { :duration => Rational(1,36), :intervals => [{:pitch => "Eb4".to_pitch}]},
  { :duration => Rational(1,36), :intervals => [{:pitch => "Db4".to_pitch}]},
  { :duration => Rational(1,6), :intervals => [{:pitch => "Ab3".to_pitch}]},
  { :duration => Rational(1,12), :intervals => [{:pitch => "Db4".to_pitch}]},
  # 1.0
  { :duration => Rational(1,6), :intervals => [{:pitch => "Bb3".to_pitch}]},
  { :duration => Rational(1,4)},
  { :duration => Rational(1,12), :intervals => [{:pitch => "Db4".to_pitch, :link => tie("Db4".to_pitch)}]},
  { :duration => Rational(1,4), :intervals => [{:pitch => "Db4".to_pitch, :link => tie("Db4".to_pitch)}]},
  { :duration => Rational(1,8), :intervals => [{:pitch => "Db4".to_pitch, :link => portamento("C4".to_pitch)}]},
  { :duration => Rational(1,8), :intervals => [{:pitch => "C4".to_pitch}]},
  # 2.0
  { :duration => Rational(1,6), :intervals => [{:pitch => "C4".to_pitch}]},
  { :duration => Rational(1,4)},
  { :duration => Rational(1,12), :intervals => [{:pitch => "Eb4".to_pitch, :link => tie("Eb4".to_pitch)}]},
  { :duration => Rational(1,6), :intervals => [{:pitch => "Eb4".to_pitch, :link => tie("Eb4".to_pitch)}]},
  { :duration => Rational(1,36), :intervals => [{:pitch => "Eb4".to_pitch}]},
  { :duration => Rational(1,36), :intervals => [{:pitch => "F4".to_pitch}]},
  { :duration => Rational(1,36), :intervals => [{:pitch => "Eb4".to_pitch}]},
  { :duration => Rational(1,6), :intervals => [{:pitch => "Bb3".to_pitch}]},
  { :duration => Rational(1,12), :intervals => [{:pitch => "Eb4".to_pitch}]},
  # 3.0
  { :duration => Rational(1,6), :intervals => [{:pitch => "C4".to_pitch}]},
  { :duration => Rational(1,4)},
  { :duration => Rational(1,12), :intervals => [{:pitch => "Eb4".to_pitch, :link => tie("Eb4".to_pitch)}]},
  { :duration => Rational(1,4), :intervals => [{:pitch => "Eb4".to_pitch, :link => tie("Eb4".to_pitch)}]},
  { :duration => Rational(1,8), :intervals => [{:pitch => "Eb4".to_pitch, :link => portamento("D4".to_pitch)}]},
  { :duration => Rational(1,8), :intervals => [{:pitch => "D4".to_pitch}]},
]

arrangement_hash = {
  :score => {
    :program => {
      :segments => [0...2, 0...2,2...4,0...2]
    },
    :tempo_profile => { :start_value => tempo(120) },
    :parts => {
      "lead" => {
        :notes => lead_notes,
        :loudness_profile => { :start_value => 0.5 }
      },
      "bass" => {
        :notes => bass_notes,
        :loudness_profile => { :start_value => 0.125 }
      }
    }
  },
  :instrument_configs => {
    'bass' => {
      :plugin_name => "synth_instr_1",
      :initial_settings => ["sawtooth"]
    },
    'lead' => {
      :plugin_name => "synth_instr_3",
      :initial_settings => ["blend", "very short attack", "med decay"]
    },
  }
}

File.open('hip.yml','w') do |file|
  file.write arrangement_hash.to_yaml
end