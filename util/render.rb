#!/usr/bin/env ruby

require 'micro-optparse'
require 'musicality'
require 'wavefile.rb'
require 'pry'

class ScoreRenderer
  
  BITS_PER_SAMPLE = 32
  MAX_SAMPLE_VALUE = (2 **(0.size * 8 - 2) - 2)
  
  def initialize args={}
    reqd = [:scorefile, :outfile]
    reqd.each {|key| raise ArgumentError, "args does not have required key #{key}" unless args.has_key?(key) }
    @scorefile = args[:scorefile]
    @outfile = args[:outfile]
    
    opts = { :samplerate => 48000.0 }.merge args
    @samplerate = opts[:samplerate]
  end
  
  def run
    score = Musicality::ScoreFile.load @scorefile
    time_conversion_sample_rate = 250.0
    conductor = Musicality::Conductor.new score, time_conversion_sample_rate, @samplerate
    
    format = WaveFile::Format.new(:mono, BITS_PER_SAMPLE, @samplerate.to_i)
    writer = WaveFile::Writer.new(@outfile, format)
    
    puts "time   sample    "
      
    samples = []
    conductor.perform do |sample|
      samples << (sample * MAX_SAMPLE_VALUE)

      if(samples.count >= 10000)
        print "%.4f:" % conductor.time_counter
        print "%08d   " % conductor.sample_counter
        print "%.4f   " % (samples.last / MAX_SAMPLE_VALUE.to_f)
        
      #  notes_played = 0
      #  notes_being_played = 0

        active_pitches = 0
        conductor.performers.each do |performer|  
          active_pitches += performer.instrument.notes.count
        end

      #  print "#{notes_played} notes played, #{notes_being_played} notes being played"
        print "#{active_pitches} active pitches"
        puts ""

        buffer = WaveFile::Buffer.new(samples, format)
        writer.write(buffer)
        
        samples.clear
      end
    end

    writer.close()
  end
end


options = Parser.new do |p|
  p.banner = <<-END
Render a Musicality score.

Usage:
      ruby render.rb [options] <filenames>+

Notes:
  Sample rate must be > 1000. 
  Output directory must already exist.

Options:
END
  p.version = "0.1"
  p.option :outdir, "set output directory", :default => "./", :value_satisfies => lambda { |path| Dir.exist? path }
  p.option :samplerate, "set sample rate", :default => 48000.0, :value_satisfies => lambda { |rate| rate > 1000.0 }
end.process!

puts "Rendering to output directory #{options[:outdir]} at sample rate #{options[:samplerate]}"

ARGV.each do |scorefile|
  if !File.exist?(scorefile)
    puts "Could not find score file #{scorefile}, skipping."
    next
  end
  
  samplerate = options[:samplerate]
  outfile = File.basename(scorefile, ".*") + ".wav"
  outpath = options[:outdir] + outfile
  
  puts "Rendering #{File.basename(scorefile)} -> #{outfile}"

  renderer = ScoreRenderer.new :scorefile => scorefile, :outfile => outfile, :sample_rate => samplerate
  renderer.run
end

