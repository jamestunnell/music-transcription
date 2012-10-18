# -*- encoding: utf-8 -*-

require File.expand_path('../lib/musicality/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "musicality"
  gem.version       = Musicality::VERSION
  gem.summary       = %q{Library for music composition, transcription, generation, and rendering}
  gem.description   = <<DESCRIPTION
The core of musicality is the abstract representation of musical constructs 
such as pitch, note, etc. Having established a representation, it is possible 
to follow the process of composition, transcription, or generation to 
represent music in software. Then, music can be either rendered as audio or 
translated to performance instructions (MIDI, sheet music).
DESCRIPTION
  gem.license       = "MIT"
  gem.authors       = ["James Tunnell"]
  gem.email         = "jamestunnell@lavabit.com"
  gem.homepage      = "https://github.com/jamestunnell/musicality"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'wavefile'

  gem.add_development_dependency 'bundler', '~> 1.0'
  gem.add_development_dependency 'rake', '~> 0.8'
  gem.add_development_dependency 'rspec', '~> 2.4'
  gem.add_development_dependency 'yard', '~> 0.8'
end
