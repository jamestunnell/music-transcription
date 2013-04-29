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
require 'musicality/model/score'
require 'musicality/model/instrument_config'
require 'musicality/model/arrangement'

# plugin architecture
require 'musicality/plugins/instrument_plugin'
require 'musicality/plugins/instrument_plugin_registry'

# performance utility classes
require 'musicality/performance/util/piecewise_function'
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

# facilitate instrument sampling
require 'musicality/sampling/sample_file'
require 'musicality/sampling/sampler'

# misc utility classes
require 'musicality/util/envelopes/adsr_envelope'
require 'musicality/util/optimization/vector'
require 'musicality/util/optimization/particle_swarm'
require 'musicality/util/pitch_constants'