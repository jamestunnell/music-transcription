module Musicality

# Program defines markers (by starting note offset) and subprograms (list which markers are played).
#
# @author James Tunnell
#
class Program
  attr_reader :start, :stop, :markers, :jumps

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ :stop ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :start, :markers, :jumps ]

  # default values for optional hashed arguments
  OPTIONAL_ARG_DEFAULTS = { :start => 0.0, :markers => {}, :jumps => [] }

  # A new instance of Program.
  # @param [Hash] args Hashed arguments. Required key is :stop. Optional keys 
  #                    are :start, :markers, and :jumps.
  def initialize args={}
    raise ArgumentError, "args does not have :stop key" if !args.has_key?(:stop)
    self.stop = args[:stop]
    opts = OPTIONAL_ARG_DEFAULTS.merge args
	  self.start = opts[:start]
	  self.markers = opts[:markers]
    self.jumps = opts[:jumps]
  end
  
  def == other
    raise ArgumentError, "program is invalid" if !self.valid?
    if self.start == other.start && self.stop == other.stop
      self_jumps = prepare_jumps_at start
      other_jumps = other.prepare_jumps_at start
      return self.jumps == other.jumps
    end
    return false
  end

  # Set the program starting note offset.
  # @param [Numeric] start The program starting note offset
  # @raise [ArgumentError] if start is not a Numeric
  def start= start
    raise ArgumentError, "start is not a Numeric" if !start.is_a?(Numeric)
  	@start = start.to_f
  end

  # Set the program ending note offset.
  # @param [Numeric] stop The program ending note offset
  # @raise [ArgumentError] if stop is not a Numeric
  def stop= stop
    raise ArgumentError, "stop is not a Numeric" if !stop.is_a?(Numeric)
  	@stop = stop.to_f
  end
  
  # Define section markers that map to their note offsets.
  # @param [Hash] markers Map section markers to their note offset.
  # @raise [ArgumentError] if markers is not a Hash.
  # @raise [ArgumentError] if any marker key is not a Symbol and not a String.
  # @raise [ArgumentError] if marker vals is not a Numeric.
  def markers= markers
    raise ArgumentError, "markers is not a Hash" if !markers.is_a?(Hash)
    
    markers.each do |key, val|
      raise ArgumentError, "key #{key} is not a String or Symbol" if !key.is_a?(String) && !key.is_a?(Symbol)
      raise ArgumentError, "val #{val} is not a Numeric" if !val.is_a?(Numeric)
    end
    
  	@markers = markers
  end
  
  # Define program jumps (changes in execution flow). A jump maps a note offset
  # or marker where execution will jump to another note offset or marker.
  # 
  # @param [Hash] jumps Map note offsets or markers to where execution will jump to.
  # @raise [ArgumentError] if jumps is not a Array.
  # @raise [ArgumentError] if any marker key is not a Numeric, Symbol, or String.
  # @raise [ArgumentError] if any marker val is not a Numeric, Symbol, or String.
  def jumps= jumps
    raise ArgumentError, "jumps is not a Array" if !jumps.is_a?(Array)
  	
  	jumps.each do |jump|
  	  raise ArgumentError, "jump #{jump} is not a Hash" if !jump.is_a?(Hash)
  	  raise ArgumentError, "jump does not have :at key" if !jump.has_key?(:at)
  	  raise ArgumentError, "jump does not have :to key" if !jump.has_key?(:to)
  	  
  	  from = jump[:at]
  	  to = jump[:to]
  	  
  	  raise ArgumentError, "jump[:at] #{from} is not a Numeric, String, or Symbol" if !from.is_a?(Numeric) && !from.is_a?(String) && !from.is_a?(Symbol)
  	  raise ArgumentError, "jump[:to] #{to} is not a Numeric, String, or Symbol" if !to.is_a?(Numeric) && !to.is_a?(String) && !to.is_a?(Symbol)
  	end
  	
  	@jumps = jumps
  end

  def valid?
    offset = @start
    
    @jumps.each do |jump|
      begin
        at = get_jump_at jump
        to = get_jump_to jump

        if offset > at
          return false
        end
        
        if stop.between?(offset, at)
          return false
        end
        
        offset = to
      rescue
        return false
      end
    end

    return offset <= stop
  end
    
  def include? target_offset
    offset = @start
    
    @jumps.each do |jump|
      at = get_jump_at jump
      to = get_jump_to jump

      # assume the program is valid and 1) current offset is less than jump[:at],
      # and 2) there's no end-of-score occuring here
      if target_offset.between?(offset, at)
        return true
      else
        offset = to
      end
    end

    #assume the program is valid and the offset is less than end-of-score
    return target_offset.between?(offset, stop)
  end

  def jumps_left_at target_offset
    offset = @start
    
    jumps_left = @jumps.count
    
    @jumps.each do |jump|
      at = get_jump_at jump
      to = get_jump_to jump

      # assume the program is valid and 1) current offset is less than jump[:at],
      # and 2) there's no end-of-score occuring here
      if target_offset.between?(offset, at)
        break
      else
        jumps_left -= 1
        offset = to
      end
    end
    
    return @jumps[(@jumps.count - jumps_left)...@jumps.count]
  end
  
  def prepare_jumps_at target_offset
    jumps = []
    self.jumps_left_at(target_offset).each do |jump|
      at = get_jump_at jump
      to = get_jump_to jump
      
      jumps << { :at => at, :to => to }
    end
    
    return jumps
  end
  
  private

  def get_jump_to jump
    to = jump[:to]

    if to.is_a?(Symbol) || to.is_a?(String)
      raise ArgumentError, "marker #{to} not found" if !@markers.has_key?(to)
      to = @markers[to]
    end
    
    return to
  end
  
  def get_jump_at jump
    at = jump[:at]
    
    if at.is_a?(Symbol) || at.is_a?(String)
      raise ArgumentError, "marker #{at} not found" if !@markers.has_key?(at)
      at = @markers[at]
    end
    
    return at
  end
end

end

