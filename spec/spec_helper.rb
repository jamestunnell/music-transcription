require 'rspec'
require 'musicality'

include Musicality

# load sample (built-in) instruments to help with testing
INSTRUMENTS.load_plugins './samples/instruments/'
