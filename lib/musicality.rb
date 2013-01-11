require 'musicality/version'

require 'musicality/core/event'
require 'musicality/core/hash_make'
require 'musicality/core/setting_profile'
require 'musicality/core/plugin_config'
require 'musicality/core/unique_token'
require 'musicality/core/piecewise_function'
require 'musicality/core/value_computer'
require 'musicality/core/value_updater'
require 'musicality/core/plugins/plugin'
require 'musicality/core/plugins/plugin_registry'
require 'musicality/core/plugins/plugins'
require 'musicality/core/plugins/plugin_view'

require 'musicality/composition/pitch'
require 'musicality/composition/note'
require 'musicality/composition/note_sequence'
require 'musicality/composition/part'
require 'musicality/composition/program'
require 'musicality/composition/score'

require 'musicality/util/pitch_constants'
require 'musicality/util/score_file'
require 'musicality/util/class_finder'
require 'musicality/util/tempo_computer'
require 'musicality/util/note_time_converter'
require 'musicality/util/signal_processing/window'
require 'musicality/util/signal_processing/signal'
require 'musicality/util/optimization/vector'
require 'musicality/util/optimization/particle_swarm'

require 'musicality/performance/util/score_collator'
require 'musicality/performance/util/score_converter'
require 'musicality/performance/util/note_sequence_combiner'
require 'musicality/performance/util/intermediate_sequencer'
require 'musicality/performance/util/instrument_finder'
require 'musicality/performance/util/instruction'

require 'musicality/performance/instrument'
require 'musicality/performance/performer'
require 'musicality/performance/conductor'

require 'musicality/performance/envelopes/adsr_envelope'
require 'musicality/performance/envelopes/flat_envelope'

require 'musicality/performance/voices/oscillator_voice'
require 'musicality/performance/voices/oscillator/oscillator'
require 'musicality/performance/voices/oscillator/sawtooth_wave'
require 'musicality/performance/voices/oscillator/sine_wave'
require 'musicality/performance/voices/oscillator/square_wave'
require 'musicality/performance/voices/oscillator/triangle_wave'

require 'musicality/performance/instruments/oscillator_instrument'

