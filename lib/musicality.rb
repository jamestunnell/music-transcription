require 'hashmake'

require 'musicality/version'
require 'musicality/unique_token'
require 'musicality/offset_limits'

# Model-related code

# note level
require 'musicality/model/pitch'
require 'musicality/model/link'
require 'musicality/model/interval'
require 'musicality/model/note'

# value/settings
require 'musicality/model/transition'
require 'musicality/model/value_change'
require 'musicality/model/profile'

# score/arrangement level
require 'musicality/model/part'
require 'musicality/model/program'
require 'musicality/model/score'
require 'musicality/model/instrument_config'
require 'musicality/model/arrangement'

require 'musicality/util/pitch_constants'
require 'musicality/util/score_file'
require 'musicality/util/tempo_computer'
require 'musicality/util/note_time_converter'
require 'musicality/util/optimization/vector'
require 'musicality/util/optimization/particle_swarm'

# Performance-related code

# settings
require 'musicality/performance/settings/piecewise_function'
require 'musicality/performance/settings/value_computer'
require 'musicality/performance/settings/value_updater'

# instrument plugins
require 'musicality/performance/instruments/instrument_plugin'
require 'musicality/performance/instruments/instrument_plugin_registry'

require 'musicality/performance/util/score_collator'
require 'musicality/performance/util/score_converter'
require 'musicality/performance/util/sequencer'
require 'musicality/performance/util/instrument_finder'
require 'musicality/performance/util/instruction'

require 'musicality/performance/key'
require 'musicality/performance/instrument'
require 'musicality/performance/performer'
require 'musicality/performance/conductor'
require 'musicality/performance/renderer'

require 'musicality/performance/envelopes/adsr_envelope'
require 'musicality/performance/envelopes/flat_envelope'
#
#require 'musicality/performance/voices/oscillator_voice'
#require 'musicality/performance/voices/oscillator/oscillator'
#require 'musicality/performance/voices/oscillator/sawtooth_wave'
#require 'musicality/performance/voices/oscillator/sine_wave'
#require 'musicality/performance/voices/oscillator/square_wave'
#require 'musicality/performance/voices/oscillator/triangle_wave'

require 'musicality/performance/instruments/synth_instrument'
