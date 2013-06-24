require 'pry'
module Musicality

# Combine multiple program segments to one, using
# tempo/note/dynamic replication and truncation where necessary.
#
# @author James Tunnell
class Score

  # Combine multiple program segments to one, using tempo/note/dynamic replication
  # and truncation where necessary. Returns a modified clone of the current score.
  #
  def collate
    return self.clone.collate!
  end
  
  # Combine multiple program segments to one, using tempo/note/dynamic replication
  # and truncation where necessary. Modifies current score.
  #
  def collate!
    return self if @program.nil?
    return self if @program.segments.count <= 1
    
    new_parts = {}
    
    # figure parts (note sequences & dynamics)
    @parts.each do |id, part|
      
      new_part = Musicality::Part.new(
	:loudness_profile => clone_and_collate_profile(
	  part.loudness_profile,
	  ValueComputer,
	  @program.segments
	),
      )
      
      @program.segments.each do |seg|
	cur_offset = part.start_offset	
	cur_notes = []
	
	part.notes.each do |note|
	  if cur_offset >= seg.first && cur_offset < seg.last
	    cur_notes.push note.clone
	  end
	  cur_offset += note.duration
	end
	
	cur_note_duration = cur_notes.inject(0){|sum,cur_note| cur_note.duration + sum }
	overshoot = cur_note_duration - (seg.last - seg.first)
	
	if overshoot > 0
	  cur_notes.last.duration -= overshoot
	end
	
	cur_note_duration = cur_notes.inject(0){|sum,cur_note| cur_note.duration + sum }
	undershoot = (seg.last - seg.first) - cur_note_duration
	if undershoot > 0
	  cur_notes.push Note.new(:duration => undershoot)
	end
	      
	if cur_notes.any?
	  # make sure the notes don't have any links past this point
	  cur_notes.last.intervals.each do |interval|
	    interval.link = Link.new
	  end
	end
	
	new_part.notes.concat cur_notes
      end
      
      new_parts[id] = new_part
    end    
    
    @parts = new_parts
    unless @tempo_profile.nil?
      @tempo_profile = clone_and_collate_profile(
	@tempo_profile,
	TempoComputer,
	@program.segments
      )
    end
    @program.segments = [self.find_start...self.find_end]
    
    return self
  end

  private
  
  def clone_and_collate_profile profile, computer_class, program_segments
    new_profile = Profile.new :start_value => profile.start_value
    
    segment_start_offset = 0.0
    comp = computer_class.new(profile)
    
    program_segments.each do |seg|
      # figure which dynamics to keep/modify
      changes = Marshal.load(Marshal.dump(profile.value_changes))
      changes.keep_if {|offset,change| seg.include?(offset) }
      changes.each do |offset, change|
	if(offset + change.transition.duration) > seg.last
	  change.transition.duration = seg.last - offset
	  change.value = comp.value_at seg.last
	end
      end
      
      # find & add segment start dynamic first
      value = comp.value_at seg.first
      offset = segment_start_offset
      new_profile.value_changes[offset] = Musicality::value_change(value)
      
      # add dynamics to part, adjusting for segment start offset
      changes.each do |offset2, change|
	offset3 = (offset2 - seg.first) + segment_start_offset
	new_profile.value_changes[offset3] = change
      end
      
      segment_start_offset += (seg.last - seg.first)
    end
    
    return new_profile
  end

end
end