require 'set'

module Musicality

# The conductor reads a score, assigns score parts to performers, prepares the 
# performers to perform, and follows the score tempo as it directs the rendering
# of performance samples.
# 
# @author James Tunnell
# 
class Conductor

  # use this to set sample rate if none is given in construction.
  DEFAULT_SAMPLE_RATE = 48000.0
  
  attr_reader :score, :sample_rate, :start_of_score, :end_of_score,
               :performers, :time_counter, :sample_counter
  
  # A new instance of Conductor.
  # @param [Score] score The score to be used during performance.
  # @param [Numeric] sample_rate The sample rate used in rendering samples.
  # @param [Numeric] conversion_sample_rate The sample rate used in converting
  #                                         from note-base to time-base
  def initialize score, sample_rate = DEFAULT_SAMPLE_RATE, conversion_sample_rate = sample_rate / 10.0
    
    raise ArgumentError, "score has no parts" unless score.parts.any?
    raise ArgumentError, "sample_rate is not a Numeric" unless sample_rate.is_a?(Numeric)
    raise ArgumentError, "sample_rate is less than 1000.0" if sample_rate < 1000.0
    raise ArgumentError, "conversion_sample_rate is not a Numeric" unless conversion_sample_rate.is_a?(Numeric)
    raise ArgumentError, "conversion_sample_rate is less than 100.0" if conversion_sample_rate < 100.0

    parts = make_time_based_parts_from_score score, conversion_sample_rate
    
    @start_of_score = parts.first.find_start
    @end_of_score = parts.first.find_end

    parts.each do |part|
      sop = part.find_start
      @start_of_score = sop if sop < @start_of_score
      
      eop = part.find_end
      @end_of_score = eop if eop > @end_of_score
    end
    
    @performers = []
    parts.each do |part|
      @performers << Performer.new(part, sample_rate)
    end
    
    @sample_rate = sample_rate
    @sample_period = 1.0 / sample_rate
    
    @time_counter = 0.0
    @sample_counter = 0
  end
  
  # Perform the entire score, producing however many samples as is necessary to
  # render the entire program length.
  def perform_score start_time = @start_of_score, lead_out_time = 0.0
    prepare_performance_at start_time
    samples = []

    while @time_counter < (@end_of_score + lead_out_time) do
      sample = perform_sample

      if block_given?
        yield sample
      else
        samples << sample
      end
    end
    
    return samples
  end

  # Perform part of the score, producing as many samples as is given by n_samples.
  # @param [Numeric] n_samples The number of samples of the score to render.
  def perform_samples n_samples, start_time = @start_of_score
    prepare_performance_at start_time
    samples = []
    
    n_samples.times do
      sample = perform_sample

      if block_given?
        yield sample
      else
        samples << sample
      end
    end
    
    return samples
  end

  # Perform part of the score, producing as many samples as is necessary to 
  # render t_seconds seconds of the score. 
  # @param [Numeric] t_seconds The number of seconds of the score to render.  
  def perform_seconds t_seconds, start_time = @start_of_score
    prepare_performance_at start_time
    samples = []
    
    while @time_counter < t_seconds do
      sample = perform_sample

      if block_given?
        yield sample
      else
        samples << sample
      end
    end
    
    return samples
  end

  ## Perform part of the score, producing as many samples as is necessary to 
  ## render n_notes notes of the score. 
  ## @param [Numeric] n_notes The number of notes of the score to render.    
  #def perform_notes
  #  prepare_performance
  #  samples = []
  #
  #  while @note_counter < n_notes
  #    sample = perform_sample
  #
  #    if block_given?
  #      yield sample
  #    else
  #      samples << sample
  #    end
  #  end
  #  
  #  return samples
  #end

  private
  
  # Give the conductor a chance to set up counters, and for performers to figure
  # which notes will be played. Must be called before any calls to 
  # perform_sample.
  def prepare_performance_at start_time = 0.0
    @time_counter = start_time
    @sample_counter = (@time_counter * @sample_period).to_i
    
    @performers.each do |performer|
      performer.prepare_performance_at @time_counter
    end
  end

  # Render an audio sample of the performance at the current note counter.
  # Increments the note counter by the current notes per sample (computed from 
  # current tempo). Increments the sample counter by 1 and the time counter by 
  # the sample period.
  def perform_sample
    sample = 0.0

    if @time_counter <= @end_of_score
      @performers.each do |performer|
        sample += performer.perform_sample(@time_counter)
      end
    end
    
    @time_counter += @sample_period
    @sample_counter += 1
    
    return sample
  end

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
      new_part = Musicality::Part.new( :start_dynamic => part.start_dynamic, :instrument => part.instrument )
      
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

