require 'hashmake'

module Musicality

# Abstraction of a musical part. Contains note sequences, loudness settings, 
# instrument plugins, and effect plugins.
#
# @author James Tunnell
#
# @!attribute [rw] note_sequences
#   @return [Array] The note sequences to be played.
#
# @!attribute [rw] loudness_profile
#   @return [SettingProfile] The parts loudness profile.
#
# @!attribute [rw] instrument_plugins
#   @return [Array] An array of plugin configs that each describe an instrument
#                        plugin to be used in performing the part and settings to
#                        apply to the plugin.
#
# @!attribute [rw] effect_plugins
#   @return [Array] An array of plugin configs that each describe an effect
#                        plugin to be used in performing the part and settings to
#                        apply to the plugin.
#
# @!attribute [rw] id
#   @return [String] An identifying string, which should be different from other part IDs.
#
class Part
  include Hashmake::HashMakeable
  attr_reader :loudness_profile, :note_sequences
  
  # hashed-arg specs (for hash-makeable idiom)
  ARG_SPECS = {
    :loudness_profile => arg_spec(:reqd => false, :type => SettingProfile, :validator => ->(a){ a.values_between?(0.0,1.0) }, :default => ->(){ SettingProfile.new(:start_value => 0.5) }),
    :note_sequences => arg_spec_array(:reqd => false, :type => NoteSequence),
  }
  
  # A new instance of Part.
  # @param [Hash] args Hashed arguments. Valid optional keys are :loudness_profile, 
  #                    :note_sequences, :instrument_plugins, :effect_plugins, and :id.
  def initialize args = {}
    hash_make ARG_SPECS, args
  end
  
  # Set the part note sequences.
  # @param [Array] note_sequences Contains note sequences to be played.
  # @raise [ArgumentError] unless note_sequences is an Array.
  # @raise [ArgumentError] unless note_sequences contains only NoteSequence objects.
  def note_sequences= note_sequences
    validate_arg ARG_SPECS[:note_sequences], note_sequences
    @note_sequences = note_sequences
  end

  # Set the loudness SettingProfile.
  # @param [Tempo] loudness_profile The SettingProfile for part loudness.
  # @raise [ArgumentError] if loudness_profile is not a SettingProfile.
  def loudness_profile= loudness_profile
    validate_arg ARG_SPECS[:loudness_profile], loudness_profile
    @loudness_profile = loudness_profile
  end
  
  # Find the start of the part. The start will be at the note or 
  # note sequence that starts first, or 0 if none have been added.
  def find_start
    sop = 0.0
 
    @note_sequences.each do |sequence|
      sos = sequence.offset
      sop = sos if sos < sop
    end

    return sop
  end

  # Find the end of the part. The end will be at then end of whichever note or 
  # note sequence ends last, or 0 if none have been added.
  def find_end
    eop = 0.0
 
    @note_sequences.each do |sequence|
      eos = sequence.offset + sequence.duration
      eop = eos if eos > eop
    end

    return eop
  end

end

end
