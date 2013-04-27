#!/usr/bin/env ruby

require 'micro-optparse'
require 'musicality'
require 'wavefile.rb'
require 'pry'
require 'yaml'

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
  p.option :verbose, "is verbose?", :default => false
end.process!

samplerate = options[:samplerate]
outdir = options[:outdir]
verbose = options[:verbose]

puts "Rendering to output dir #{outdir} at sample rate #{samplerate}"

ARGV.each do |filename|
 
  if !File.exist?(filename)
    puts "Could not find arrangement file #{filename}, skipping."
    next
  end

  if verbose
    puts
  end

  outfile = File.basename(filename, ".*") + ".wav"
  outpath = outdir + outfile

  File.open(filename, "r") do |file|
    hash = YAML.load file.read
    arrangement = Musicality::Arrangement.new hash

    format = WaveFile::Format.new(:mono, :float_32, samplerate.to_i)
    writer = WaveFile::Writer.new(outfile, format)
    
    print "Rendering #{File.basename(filename)} -> #{outfile} "
    if verbose
      puts
      puts "time   sample   avg    active keys"
    else
      print "  0.0%"
    end
    
    chunk_size = 100
    start_time = Time.now
    
    conductor = Musicality::Conductor.new(
      :arrangement => arrangement,
      :time_conversion_sample_rate => 250,
      :rendering_sample_rate => samplerate,
      :sample_chunk_size => chunk_size
    )
    
    while conductor.time_counter < conductor.end_of_score
      conductor.perform_samples(chunk_size) do |new_samples|
        buffer = WaveFile::Buffer.new(new_samples, format)
        writer.write(buffer)
        
        if verbose
          avg = new_samples.inject(0){|sum,a| sum + a } / new_samples.count
          keys = conductor.performers.inject(0){|active_keys, performer| active_keys + performer.instrument.active_keys.count }
          
          print "%.4f " % conductor.time_counter
          print "%08d " % conductor.sample_counter
          print "%.4f " % avg
          puts keys
        else
          print "\b" * 6
          print "%5.1f%%" % (100 * conductor.time_counter / conductor.end_of_score)
        end
      end
    end

    elapsed_sec = Time.now - start_time
    minutes = (elapsed_sec / 60).to_i
    seconds = (elapsed_sec % 60)
    
    if(minutes == 0)
      elapsed_time_str = "%.1f sec" % seconds
    else
      elapsed_time_str = "%d min %.1f sec" % [minutes, seconds]
    end

    if verbose
      puts
      puts "Completed in #{elapsed_time_str}"
    else
      puts " in #{elapsed_time_str}"
    end
    
    writer.close()
  end
end

