require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'spcore'

describe Musicality::ADSRMeasurement do
  it 'should correctly measure signal with bell-shaped envelope' do
    sample_rate = 5120
    size = 512
    total_time = size.to_f / sample_rate
    signal = SPCore::SignalGenerator.new(:sample_rate => sample_rate, :size => size).make_signal([100.0])
    window = SPCore::HannWindow.new(size)
    signal.multiply! window.data
    
    half_time = total_time / 2.0
    margin = total_time / 10.0
      
    measurement = ADSRMeasurement.new(:signal => signal)
    measurement.attack_time.should be_within(margin).of(half_time)
    measurement.attack_height.should be_within(0.1).of(1.0)
    #measurement.decay_time.should be_within(margin).of(half_time)
    #measurement.sustain_time.should be_within(margin).of(0.0)
  end

  it 'should correctly measure signal with half a bell-shaped envelope' do
    sample_rate = 5120
    size = 512
    total_time = size.to_f / sample_rate
    signal = SPCore::SignalGenerator.new(:sample_rate => sample_rate, :size => size).make_signal([100.0])
    window = SPCore::HannWindow.new(size)
    signal.multiply! window.data
    half = signal.subset((size / 2)...size)
    
    half_time = total_time / 2.0
    margin = total_time / 10.0

    measurement = ADSRMeasurement.new(:signal => half)      
    measurement.attack_time.should be_within(margin).of(0.0)
    measurement.attack_height.should be_within(0.1).of(1.0)
    #measurement.decay_time.should be_within(margin).of(half_time)
    #measurement.sustain_time.should be_within(margin).of(0.0)
  end

  it 'should correctly measure signal with envelope that starts with bell-shape and sustains before release' do
    sample_rate = 5120
    
    segment_size = 256
    bell_size = 2 * segment_size
    plateau_size = 4 * segment_size
    
    bell = SPCore::HannWindow.new(bell_size).data + Array.new(3 * segment_size, 0.0)
    plateau = Array.new(1 * segment_size, 0.0) + SPCore::TukeyWindow.new(plateau_size).data
    modulation = SPCore::Signal.new(:sample_rate => sample_rate, :data => plateau)
    modulation.multiply! 0.7
    modulation.add! bell
    
    total_size = modulation.size
    total_time = (total_size).to_f / sample_rate
    
    signal = SPCore::SignalGenerator.new(:sample_rate => sample_rate, :size => total_size).make_signal([100.0])
    modulated_signal = signal.multiply(modulation)
    
    #SPCore::Plotter.new.plot_signals("unmodulated signal" => signal, "modulation" => modulation, "modulated signal" => modulated_signal)
    
    envelope = modulated_signal.envelope
    
    expected_attack_time = (bell_size / 2.0) / sample_rate
    expected_attack_height = envelope[(expected_attack_time * sample_rate).to_i]
    #expected_decay_time = expected_attack_time
    #expected_sustain_height = 0.25
    #expected_sustain_time = (plateau_size / 2.0) / sample_rate
    #expected_release_time = (plateau_size / 4.0) / sample_rate
    
    time_margin = 0.01
    height_margin = 1.0 / 10.0
    
    measurement = ADSRMeasurement.new(:signal => modulated_signal)
    
    measurement.attack_time.should be_within(time_margin).of(expected_attack_time)
    measurement.attack_height.should be_within(height_margin).of(expected_attack_height)
    #measurement.decay_time.should be_within(time_margin).of(expected_decay_time)
    #measurement.sustain_time.should be_within(time_margin).of(expected_sustain_time)
    #measurement.sustain_height.should be_within(height_margin).of(expected_sustain_height)
    #measurement.release_time.should be_within(time_margin).of(expected_release_time)
  end

end