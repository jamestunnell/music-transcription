module Music
module Transcription

class MeasureScore
  # Convert to NoteScore object by first converting measure-based offsets to
  # note-based offsets, and eliminating the use of meters. Also, tempo is
  # converted from beats-per-minute to notes-per-minute.
  def to_note_score desired_tempo_class = Tempo::QNPM
    unless valid?
      raise NotValidError, "Current MeasureScore is invalid, so it can not be \
                            converted to a NoteScore. Validation errors: #{self.errors}"
    end
    
    unless NoteScore.valid_tempo_types.include? desired_tempo_class
      raise TypeError, "The desired tempo class #{desired_tempo_class} is not valid for a NoteScore."
    end
    
    mnoff_map = measure_note_offset_map
    
    # convert parts
    # convert program
    # convert start tempo
    start_tempo = convert_tempo(0,@start_tempo,desired_tempo_class)
    # convert tempo changes
    NoteScore.new(start_tempo)
  end
  
  def convert_tempo moff, src_tempo, dest_class
    args = (src_tempo.class == Tempo::BPM) ? [beat_duration_at(moff)] : []
    
    return case dest_class.new(1)
    when src_tempo.class then src_tempo.clone
    when Tempo::QNPM then @start_tempo.to_qnpm(*args)
    when Tempo::NPM then @start_tempo.to_npm(*args)
    when Tempo::NPS then @start_tempo.to_nps(*args)
    else
      raise TypeError, "Unexpected destination tempo class #{dest_class}"
    end
  end
  
  def beat_duration_at moff
    beat_durations.select {|k,v| k <= moff }.max[1]
  end
  
  def measure_offsets
    moffs = Set.new([0.to_r])
    
    @tempo_changes.each do |moff,change|
      moffs.add(moff)
      if change.duration > 0
        moffs.add(moff + change.duration)
      end
    end
    
    @meter_changes.keys.each {|moff| moffs.add(moff) }
    
    @parts.values.each do |part|
      part.dynamic_changes.each do |moff,change|
        moffs.add(moff)
        if change.duration > 0
          moffs.add(moff + change.duration)
        end
      end
    end
    
    @program.segments.each do |seg|
      moffs.add(seg.first)
      moffs.add(seg.last)
    end
    
    return moffs.sort
  end

  def beat_durations
    bdurs = @meter_changes.map do |offset,change|
      [ offset, change.value.beat_duration ]
    end.sort
    
    if bdurs.empty? || bdurs[0][0] != 0
      bdurs.unshift([0,@start_meter.beat_duration])
    end
  
    return bdurs
  end
  
  def measure_durations
    mdurs = @meter_changes.map do |offset,change|
      [ offset, change.value.measure_duration ]
    end.sort
    
    if mdurs.empty? || mdurs[0][0] != 0
      mdurs.unshift([0,@start_meter.measure_duration])
    end
  
    return mdurs
  end
  
  def measure_note_offset_map
    mnoff_map = { 0.to_r => 0.to_r }
    
    moffs = measure_offsets
    j = 0 # next measure offset to be converted
    mdurs = measure_durations
    
    (0...(mdurs.size-1)).each do |i|
      cur_moff, mdur = mdurs[i]
      next_moff = mdurs[i+1][0]
      
      while(j < moffs.size && moffs[j] < next_moff) do
        moff = moffs[j]
        mnoff_map[moff] = cur_moff + (moff - cur_moff)*mdur
        j += 1
      end
    end
    
    cur_moff, mdur = mdurs[-1]
    while(j < moffs.size) do
      moff = moffs[j]
      mnoff_map[moff] = cur_moff + (moff - cur_moff)*mdur
      j += 1
    end
    
    return mnoff_map
  end
end
  
end
end