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
  gem.email         = "jamestunnell@lavabit.com"
  gem.homepage      = "https://github.com/jamestunnell/music-transcription"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'hashmake'
  # gem.add_dependency 'spnet'
  # gem.add_dependency 'spcore'
  # gem.add_dependency 'micro-optparse'
  # gem.add_dependency 'wavefile'
  
  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'pry-nav'
end
