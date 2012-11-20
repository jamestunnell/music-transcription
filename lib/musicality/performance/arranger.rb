module Musicality

# Finds an instrument for each part in a score.
#
# @author James Tunnell
#
# @!attribute [r] default_instrument_config
#   @return [InstrumentConfig] If no config is specific for a part, or if the
#                              config cannot be used, the default config will
#                              be used.
#
class Arranger

  attr_reader :default_instrument_config

  # A new instance of Arranger.
  #
  # @param [Hash] args Hashed arguments. Optional keys are
  #                    :default_instrument_plugin and :plugin_dirs.
  def initialize args = {}
    opts = {
      :default_instrument_plugin => PluginConfig.new(
        :name => 'oscillator', :settings => { :wave => 'square' }
      ),
      :plugin_dirs => [""]
    }.merge args
    
    @default_instrument_config = opts[:default_instrument_config]
    
    #TODO use PlugMan to load all plugins in these dirs...
    
    #TODO Check to make sure that the default instrument plugin is found and valid
  end
  
  # Make an Arrangment from a Score, which includes converting note-based
  # offsets & durations to time-based.
  # @param [Score] score The score to be used to make an Arrangement.
  # @param [Numeric] conversion_sample_rate The sample rate used in converting
  #                                         from note-base to time-base
  def make_arrangement score, conversion_sample_rate = 1000.0
    raise ArgumentError, "score has no parts" unless score.parts.any?
    raise ArgumentError, "conversion_sample_rate is not a Numeric" unless conversion_sample_rate.is_a?(Numeric)
    raise ArgumentError, "conversion_sample_rate is less than 100.0" if conversion_sample_rate < 100.0

    parts = make_time_based_parts_from_score score, conversion_sample_rate
    
    # TODO make instruments for the part, using part.instrument_plugins.
    # Assign instrument to part id in instrument_map hash.
    instrument_map = {}
    
    # TODO make effects for the part, using part.effect_plugins
    # Assign effect to part id in effect_map hash.
    effect_map = {}
    
    return Arrangement.new(parts, instrument_map, effect_map)
  end
  
  private
  
  ## Find an instrument class for each of the given parts.
  #def map_parts_to_instruments parts
  #  parts_to_instruments = {}
  #  
  #  parts.each do |part|
  #    config = part.instrument_config
  #    config.makemodel_list.each do |makemodel|
  #    end
  #    klass = find_instrument_class settings
  #    parts_to_instruments[part.id] = klass
  #  end
  #  return parts_to_instruments
  #end
  #
  ## Find an instrument matching the specied settings.
  #def find_instrument_class settings
  #  raise ArgumentError, "settings does not have :make key" unless settings.has_key?(:make)
  #  raise ArgumentError, "settings does not have :type key" unless settings.has_key?(:type)
  #  raise ArgumentError, "settings does not have :subtype key" unless settings.has_key?(:subtype)
  #  
  #  make = settings[:make]
  #  type = settings[:type]
  #  subtype = settings[:subtype]
  #  
  #  raise ArgumentError, "Could not find find make #{make}" unless ClassFinder.find_by_name(make)
  #  
  #  klass = ClassFinder.find_by_name("#{make}::#{subtype}")
  #  
  #  if klass.nil?
  #    klass = ClassFinder.find_by_name("#{make}::#{type}#{subtype}")
  #  end
  #  
  #  if klass.nil?
  #    klass = ClassFinder.find_by_name("#{make}::#{type}::#{subtype}")
  #  end
  #  
  #  if klass.nil?
  #    klass = ClassFinder.find_by_name("#{make}::#{type}")
  #  end
  #  
  #  raise ArgumentError, "no class foud for #{subtype} #{type}" if klass.nil?
  #  return klass
  #end

  # Convert note-based offsets & durations to time-based. This eliminates
  # the use of tempo during performance.
  # @param [Score] score The score to process. It will be collated if
  #                      it is not already.
  # @param [Numeric] conversion_sample_rate The sample rate to use in
  #                                         converting from note-base to
  #                                         time-base.
  def make_time_based_parts_from_score score, conversion_sample_rate
    
    ScoreCollator.collate_score score
    
    #gather all the note offets to be converted to time offsets
    
    note_offsets = Set.new [0.0]
    
    score.parts.each do |part|
      part.sequences.each do |sequence|
        offset = sequence.offset
        note_offsets << offset
        
        sequence.notes.each do |note|
          offset += note.duration
          note_offsets << offset
        end
      end
      
      part.dynamic_changes.each do |a|
        note_offsets << a.offset
      end
    end
    
    # convert note offsets to time offsets
    
    tempo_computer = TempoComputer.new( score.start_tempo, score.tempo_changes )
    note_time_converter = NoteTimeConverter.new tempo_computer, conversion_sample_rate
    note_time_map = note_time_converter.map_note_offsets_to_time_offsets note_offsets
    
    new_parts = []
    score.parts.each do |part|
      new_part = Musicality::Part.new(
        :start_dynamic => part.start_dynamic,
	:instrument_plugins => part.instrument_plugins,
	:effect_plugins => part.effect_plugins,
        :id => part.id
      )
      
      part.sequences.each do |sequence|
        
        note_start_offset = sequence.offset
        raise "Note-time map does not have sequence start note offset key #{note_start_offset}" unless note_time_map.has_key?(note_start_offset)
        new_sequence = Musicality::Sequence.new :offset => note_time_map[note_start_offset]
        
        sequence.notes.each do |note|
          note_end_offset = note_start_offset + note.duration
          
          raise "Note-time map does not have note start offset key #{note_start_offset}" unless note_time_map.has_key?(note_start_offset)
          raise "Note-time map does not have note end offset key #{note_end_offset}" unless note_time_map.has_key?(note_end_offset)
          
          time_duration = note_time_map[note_end_offset] - note_time_map[note_start_offset]
          new_note = Musicality::Note.new(
            :duration => time_duration, :pitches => note.pitches, :sustain => note.sustain,
            :attack => note.attack, :seperation => note.seperation, :relationship => note.relationship
          )
          
          new_sequence.notes << new_note
          note_start_offset += note.duration
        end
        
        new_part.sequences << new_sequence
      end
      
      part.dynamic_changes.each do |a|
        note_start_offset = a.offset
        note_end_offset = note_start_offset + a.duration
        raise "Note-time map does not have note start offset key #{note_start_offset}" unless note_time_map.has_key?(note_start_offset)
        raise "Note-time map does not have note end offset key #{note_end_offset}" unless note_time_map.has_key?(note_end_offset)
        
        start_time = note_time_map[note_start_offset]
        duration = note_time_map[note_end_offset] - start_time
        
        new_dynamic = Musicality::Dynamic.new :offset => start_time, :duration => duration, :loudness => a.loudness
        new_part.dynamic_changes << new_dynamic
      end
      
      new_parts << new_part
    end
    
    return new_parts
  end

end
end
