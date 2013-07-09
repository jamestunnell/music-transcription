require 'hashmake'

# basic core classes
require 'musicality/version'
require 'musicality/unique_token'
require 'musicality/offset_limits'

# Model-related code
require 'musicality/model/pitch'
require 'musicality/model/link'
require 'musicality/model/interval'
require 'musicality/model/note'
require 'musicality/model/transition'
require 'musicality/model/value_change'
require 'musicality/model/profile'
require 'musicality/model/part'
require 'musicality/model/program'
require 'musicality/model/tempo'
require 'musicality/model/score'
require 'musicality/model/instrument_config'
require 'musicality/model/arrangement'

# plugin architecture
require 'musicality/plugins/instrument_plugin'
require 'musicality/plugins/instrument_plugin_registry'

# practice - for learning about how to play (perform) instruments
require 'musicality/practice/envelope_dissection'
require 'musicality/practice/measurement/adsr_measurement'

# performance utility classes
require 'musicality/performance/util/value_computer'
require 'musicality/performance/util/value_updater'
require 'musicality/performance/util/note_time_converter'
require 'musicality/performance/util/tempo_computer'
require 'musicality/performance/util/score_collator'
require 'musicality/performance/util/score_converter'
require 'musicality/performance/util/instruction'
require 'musicality/performance/util/sequencer'

# performance classes
require 'musicality/performance/key'
require 'musicality/performance/instrument'
require 'musicality/performance/performer'
require 'musicality/performance/conductor'

# misc utility classes
require 'musicality/util/envelopes/adsr_envelope'
require 'musicality/util/functions/one_variable_function'
require 'musicality/util/functions/piecewise_function'
require 'musicality/util/functions/two_variable_function'
require 'musicality/util/optimization/vector'
require 'musicality/util/optimization/particle_swarm'
require 'musicality/util/sampling/sample_file'
require 'musicality/util/sampling/sampler'
require 'musicality/util/pitch_constants'

# some instrument classes that can be used for instrument plugins
require 'musicality/instruments/synth_instrument'

# some instrument classes that can be used for instrument plugins
require 'musicality/composition/rhythmic_pattern'
require 'musicality/composition/pitch_class_set'
require 'musicality/composition/pitch_class_arpeggiator'
require 'musicality/composition/interval_vector'
require 'musicality/composition/interval_vector_arpeggiator'
