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
    # convert tempo changes
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