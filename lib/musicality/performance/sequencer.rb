module Musicality

class NoteEvent < Event
  attr_reader :note
  def initialize offset, note
    @note = note
    super(offset, note.duration)
  end
end

class Sequencer
  attr_reader :sequence, :note_events, :note_events_future, :note_events_current, :note_events_past
  def initialize sequence
    @sequence = sequence
    
    @note_events = []
    offset = @sequence.offset
    @sequence.notes.each do |note|
      @note_events << NoteEvent.new(offset, note)
      offset += note.duration
    end
    
    @note_events_future = []
    @note_events_current = []
    @note_events_past = []
  end

  def prepare_to_perform start_offset = 0.0
    @note_events_future.clear
    @note_events_current.clear
    @note_events_past.clear
    
    @note_events_future = @note_events.select { |event| event.offset >= start_offset }
    @note_events_past = @note_events.select { |event| event.offset < start_offset }
#    update_notes start_offset
  end

  def update_notes note_counter
    to_start = @note_events_future.select { |event| event.offset <= note_counter }

    to_start.each do |event|
      @note_events_current << event
      @note_events_future.delete event
    end
    
    to_end = @note_events_current.select { |event| note_counter >= (event.offset + event.duration) }

    to_end.each do |event|
      @note_events_past << event
      @note_events_current.delete event
    end
    
    return { :to_start => to_start, :to_end => to_end }
  end
  
  def active?
    !@note_events_current.empty?
  end
end

end

