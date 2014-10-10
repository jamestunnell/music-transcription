# -*- encoding: utf-8 -*-

require File.expand_path('../lib/music-transcription/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "music-transcription"
  gem.version       = Music::Transcription::VERSION
  gem.summary       = %q{Classes for representing music notational features like pitch, note, loudness, tempo, etc.}
  gem.description   = <<DESCRIPTION
The goal of music-transcription is the abstract representation of standard 
musical features such as pitch, note, loudness, tempo, etc. Establishing
a common representation enables composition and performance.
DESCRIPTION
  gem.license       = "MIT"
  gem.authors       = ["James Tunnell"]
  gem.email         = "jamestunnell@gmail.com"
  gem.homepage      = "https://github.com/jamestunnell/music-transcription"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  
  gem.add_development_dependency 'bundler', '~> 1.5'
  gem.add_development_dependency 'rubygems-bundler', '~> 1.4'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-nav'
  gem.add_development_dependency 'pry-stack_explorer'
  
  gem.add_dependency 'treetop'
end
