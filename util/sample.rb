#!/usr/bin/env ruby

require 'micro-optparse'
require 'pry'
require 'musicality'

include Musicality

options = Parser.new do |p|
  p.banner = <<-END
Sample a Musicality instrument.

Usage:
      ruby sample.rb [options] <instrument_name> <preset_name>

Notes:
  Sample rate must be > 1000. 
  Output directory must already exist.

Options:
END
  p.version = "0.1"
  p.option :outdir, "set output directory", :default => "./", :value_satisfies => lambda { |path| Dir.exist? path }
  p.option :samplerate, "set sample rate", :default => 48000, :value_satisfies => lambda { |rate| rate.is_a?(Fixnum) && rate > 1000 }
  p.option :duration_sec, "duration of sample file", :default => 0.5, :value_satisfies => lambda { |duration| duration > 0 }
  p.option :verbose, "is verbose?", :default => false
end.process!

samplerate = options[:samplerate]
outdir = File.expand_path(options[:outdir])
verbose = options[:verbose]
duration_sec = options[:duration_sec].to_f

if ARGV.count != 2
  raise ArgumentError, "Instrument name and Preset name must be given. Aborting."
  return
end

instrument_config = InstrumentConfig.new(
  :plugin_name => ARGV[0],
  :initial_settings => ARGV[1]
)

# load sample (built-in) instrument plugins
instrument_plugins_dir = File.expand_path File.dirname(__FILE__) + '/../samples/instruments'
puts "Loading built-in instrument plugins from #{instrument_plugins_dir}"
Musicality::INSTRUMENTS.load_plugins instrument_plugins_dir

puts "Output dir: #{outdir}"
puts "Sample rate: #{samplerate}"
puts "Duration (sec): #{duration_sec}"
puts "Instrument: #{instrument_config.plugin_name}"
puts "Preset: #{instrument_config.initial_settings}"
puts 
print "Rendering sample files:"

start_time = Time.now
sampler = Sampler.new(:output_dir => "#{outdir}/#{instrument_config.plugin_name}/#{instrument_config.initial_settings}")
PITCHES.each do |pitch|
  print " #{pitch.to_s}"
  
  sf = SampleFile.new(
    :file_name => "#{pitch.to_s}.wav",
    :sample_rate => samplerate,
    :duration_sec => duration_sec,
    :instrument_config => instrument_config,
    :pitch => pitch,
    :attack => 0.5,
    :sustain => 0.5,
    :separation => 0.5,
  )
  sampler.render_wav sf
end

elapsed_sec = Time.now - start_time
minutes = (elapsed_sec / 60).to_i
seconds = (elapsed_sec % 60)

if(minutes == 0)
  elapsed_time_str = "%.1f sec" % seconds
else
  elapsed_time_str = "%d min %.1f sec" % [minutes, seconds]
end

puts " done in #{elapsed_time_str}."