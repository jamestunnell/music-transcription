# basic core classes
require 'music-transcription/version'
require 'music-transcription/validatable'
require 'music-transcription/errors'

# code for transcribing (representing) music
require 'music-transcription/model/pitch'
require 'music-transcription/model/pitches'
require 'music-transcription/model/link'
require 'music-transcription/model/articulations'
require 'music-transcription/model/note'
require 'music-transcription/model/dynamics'
require 'music-transcription/model/change'
require 'music-transcription/model/part'
require 'music-transcription/model/program'
require 'music-transcription/model/tempo'
require 'music-transcription/model/meter'
require 'music-transcription/model/meters'
require 'music-transcription/model/score'

require 'treetop'
require 'music-transcription/parsing/numbers/nonnegative_integer_parsing'
require 'music-transcription/parsing/numbers/positive_integer_parsing'
require 'music-transcription/parsing/numbers/nonnegative_float_parsing'
require 'music-transcription/parsing/numbers/nonnegative_rational_parsing'
require 'music-transcription/parsing/pitch_parsing'
require 'music-transcription/parsing/pitch_node'
require 'music-transcription/parsing/duration_parsing'
require 'music-transcription/parsing/duration_nodes'
require 'music-transcription/parsing/articulation_parsing'
require 'music-transcription/parsing/link_parsing'
require 'music-transcription/parsing/link_nodes'
require 'music-transcription/parsing/note_parsing'
require 'music-transcription/parsing/note_node'
require 'music-transcription/parsing/meter_parsing'
require 'music-transcription/parsing/segment_parsing'
require 'music-transcription/parsing/convenience_methods'

require 'music-transcription/packing/change_packing'
require 'music-transcription/packing/part_packing'
require 'music-transcription/packing/program_packing'
