#!/usr/bin/env ruby

require 'micro-optparse'
require 'musicality'
require 'wavefile.rb'
require 'pry'
require 'yaml'

# Renders an arrangement.
class Renderer
  
  # Render the given arrangement at the given sample rate.
  def self.render arrangement, sample_rate
    time_conversion_sample_rate = 250.0
    conductor = Musicality::Conductor.new arrangement, time_conversion_sample_rate, sample_rate
    #binding.pry
    
    unless block_given?
      puts "time   sample    "
    end
    
    samples = []
    conductor.perform do |sample|
      if block_given?
        yield sample
      else
        samples << sample

        if(samples.count % 10000 == 0)
          print "%.4f:" % conductor.time_counter
          print "%08d   " % conductor.sample_counter
          print "%.4f   " % samples.last
  
          active_keys = 0
          conductor.performers.each do |performer|  
            active_keys += performer.instrument.active_keys.count
          end
  
          print "#{active_keys} active keys"
          puts ""
        end
      end
    end
    
    return samples
  end
end

options = Parser.new do |p|
  p.banner = <<-END
Render a Musicality arrangement.

Usage:
      ruby render.rb [options] <filenames>+

Notes:
  Sample rate must be > 1000. 
  Output directory must already exist.

Options:
END
  p.version = "0.1"
  p.option :outdir, "set output directory", :default => "./", :value_satisfies => lambda { |path| Dir.exist? path }
  p.option :samplerate, "set sample rate", :default => 48000, :value_satisfies => lambda { |rate| rate.is_a?(Fixnum) && rate > 1000 }
end.process!

puts "Rendering to output directory #{options[:outdir]} at sample rate #{options[:samplerate]}"

ARGV.each do |filename|
  if !File.exist?(filename)
    puts "Could not find arrangement file #{filename}, skipping."
    next
  end

  samplerate = options[:samplerate]
  outfile = File.basename(filename, ".*") + ".wav"
  outpath = options[:outdir] + outfile

  File.open(filename, "r") do |file|
    hash = YAML.load file.read
    arrangement = Musicality::Arrangement.new hash

    format = WaveFile::Format.new(:mono, :float_32, samplerate.to_i)
    writer = WaveFile::Writer.new(outfile, format)
    
    puts "Rendering #{File.basename(filename)} -> #{outfile}"
    
    samples = Renderer.render(arrangement, samplerate)
    buffer = WaveFile::Buffer.new(samples, format)
    
    writer.write(buffer)
    writer.close()
  end
end

