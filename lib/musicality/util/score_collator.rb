module Musicality

# Combine multiple program segments to one, using
# tempo/note/dynamic replication and truncation where necessary.
#
# @author James Tunnell
class ScoreCollator
  
  # Combine multiple program segments to one, using
  # tempo/note/dynamic replication and truncation where necessary.
  #
  # @param [Score] score The score to be collated.
  #
  def self.collate_score score
    return unless score.program.segments.count > 1
    
    new_parts = []
    
    # figure parts (note sequences & dynamics)
    score.parts.each do |part|
      
      new_part = Musicality::Part.new(
	:start_dynamic => part.start_dynamic,
	:instrument_plugins => part.instrument_plugins,
	:effect_plugins => part.effect_plugins,
	:id => part.id
      )
      segment_start_offset = 0.0
      dyn_comp = DynamicComputer.new part.start_dynamic, part.dynamic_changes
      
      score.program.segments.each do |seg|
	# figure which sequences to keep/modify
	sequences = Marshal.load(Marshal.dump(part.sequences))
	sequences.each do |seq|
	  modify_seq_for_segment seq, seg
	end
	sequences.keep_if {|seq| seq.notes.any? }

	# add sequences to part, adjusting for segment start offset
	sequences.each do |sequence|
	  sequence.offset = (sequence.offset - seg.first) + segment_start_offset
	  new_part.sequences << sequence
	end	
	
	# figure which dynamics to keep/modify
	dynamic_changes = Marshal.load(Marshal.dump(part.dynamic_changes))
	dynamic_changes.keep_if {|dyn| dyn.offset >= seg.first && dyn.offset < seg.last}
	dynamic_changes.each do |dyn|
	  modify_dyn_for_segment dyn, seg, dyn_comp
	end
	
	# find & add segment start dynamic first
	loudness = dyn_comp.loudness_at seg.first
	offset = segment_start_offset
	new_part.dynamic_changes << Dynamic.new(:offset => offset, :loudness => loudness)
	
	# add dynamics to part, adjusting for segment start offset
	dynamic_changes.each do |dynamic|
	  dynamic.offset = (dynamic.offset - seg.first) + segment_start_offset
	  new_part.dynamic_changes << dynamic
	end	
	
	segment_start_offset += (seg.last - seg.first)
      end
      
      new_parts << new_part
    end    
    score.parts = new_parts
    
    # figure tempo changes
    
    tempo_comp = TempoComputer.new score.start_tempo, score.tempo_changes
    new_tempo_changes = []
    segment_start_offset = 0.0

    score.program.segments.each do |seg|
      # figure which dynamics to keep/modify
      tempo_changes = Marshal.load(Marshal.dump(score.tempo_changes))
      tempo_changes.keep_if {|tempo| tempo.offset >= seg.first && tempo.offset < seg.last}
      tempo_changes.each do |tempo|
	modify_tempo_for_segment tempo, seg, tempo_comp
      end
      
      # find & add segment start dynamic first
      nps = tempo_comp.notes_per_second_at seg.first
      bpm = (nps / 0.25) * 60.0
      offset = segment_start_offset
      new_tempo_changes << Tempo.new(:offset => offset, :beats_per_minute => bpm, :beat_duration => 0.25)
      
      # add dynamics to part, adjusting for segment start offset
      tempo_changes.each do |tempo|
	tempo.offset = (tempo.offset - seg.first) + segment_start_offset
	new_tempo_changes << tempo
      end	
      
      segment_start_offset += (seg.last - seg.first)
    end
    
    score.tempo_changes = new_tempo_changes
  end

  private
  
  def self.modify_seq_for_segment seq, seg
    start_offset = seq.offset
    notes = []
    
    seq.notes.each do |note|
      if start_offset < seg.first
	seq.offset += note.duration
      elsif start_offset < seg.last
	if (start_offset + note.duration) > seg.last
	  #reach last sequence note in segment
	  note.duration = seg.last - start_offset
	  notes << note
	  break
	end
	
	notes << note
      else
	break
      end
      
      start_offset += note.duration
    end
    
    seq.notes = notes
  end
  
  def self.modify_dyn_for_segment dyn, seg, computer
    if(dyn.offset + dyn.duration) > seg.last
      dyn.duration = seg.last - dyn.offset
      dyn.loudness = computer.loudness_at seg.last
    end
  end

  def self.modify_tempo_for_segment tempo, seg, computer
    if(tempo.offset + tempo.duration) > seg.last
      tempo.duration = seg.last - tempo.offset
      tempo.notes_per_second = computer.notes_per_second_at seg.last
    end
  end
  
end
end