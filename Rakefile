# encoding: utf-8

require 'rubygems'

begin
  require 'bundler'
rescue LoadError => e
  warn e.message
  warn "Run `gem install bundler` to install Bundler."
  exit -1
end

begin
  Bundler.setup(:development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems."
  exit e.status_code
end

require 'rake'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

task :test    => :spec
task :default => :spec

require "bundler/gem_tasks"

require 'yard'
YARD::Rake::YardocTask.new  
task :doc => :yard

task :make_examples do
  current_dir = Dir.getwd
  examples_dir = File.join(File.dirname(__FILE__), 'examples')
  Dir.chdir examples_dir
  
  examples = []
  Dir.glob('**/make*.rb') do |file|
    examples.push File.expand_path(file)
  end
  
  examples.each do |example|
    dirname = File.dirname(example)
    filename = File.basename(example)
    
    Dir.chdir dirname
    ruby filename
  end

  Dir.chdir current_dir
end
