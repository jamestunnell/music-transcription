require 'musicality'

Musicality::SynthInstrument.make_and_register_plugin 1,
  "sine" => {
    "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SQUARE,
  },
  "square" => {
    "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SINE,
  },
  "triangle" => {
    "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SINE,
  },
  "sawtooth" => {
    "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SAWTOOTH,
  }

Musicality::SynthInstrument.make_and_register_plugin 3,
  "blend" => {
    "harmonic_0_partial" => 0,
    "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SQUARE,
    "harmonic_0_amplitude" => 0.2,
    "harmonic_1_partial" => 1,
    "harmonic_1_wave_type" => SPCore::Oscillator::WAVE_SINE,
    "harmonic_1_amplitude" => 0.1,
    "harmonic_2_partial" => 2,
    "harmonic_2_wave_type" => SPCore::Oscillator::WAVE_SAWTOOTH,
    "harmonic_2_amplitude" => 0.05,
  },
  "sines" => {
    "harmonic_0_partial" => 0,
    "harmonic_0_wave_type" => SPCore::Oscillator::WAVE_SINE,
    "harmonic_0_amplitude" => 0.5,
    "harmonic_1_partial" => 1,
    "harmonic_1_wave_type" => SPCore::Oscillator::WAVE_SINE,
    "harmonic_1_amplitude" => 0.3,
    "harmonic_2_partial" => 2,
    "harmonic_2_wave_type" => SPCore::Oscillator::WAVE_SINE,
    "harmonic_2_amplitude" => 0.2,
  }
