module Musicality

# Program defines markers (by starting note offset) and subprograms (list which markers are played).
#
# @author James Tunnell
#
class Program
  attr_reader :start, :markers, :jumps

  # required hash-args (for hash-makeable idiom)
  REQUIRED_ARG_KEYS = [ ]
  # optional hash-args (for hash-makeable idiom)
  OPTIONAL_ARG_KEYS = [ :start, :markers, :jumps ]

  # default values for optional hashed arguments
  OPTIONAL_ARG_DEFAULTS = { :start => 0.0, :markers => {}, :jumps => {} }
  
  # A new instance of Score.
  # @param [Hash] options Optional arguments. Valid keys are :start, :markers, and :jumps.
  def initialize options={}
    opts = OPTIONAL_ARG_DEFAULTS.merge options
	  self.start = opts[:start]
	  self.markers = opts[:markers]
    self.jumps = opts[:jumps]
  end

  # Set the program starting note offset.
  # @param [Numeric] start The program starting note offset
  # @raise [ArgumentError] if start is not a Numeric
  def start= start
    raise ArgumentError, "start is not a Numeric" if !start.is_a?(Numeric)
  	@start = start.to_f
  end

  # Define section markers that map to their note offsets.
  # @param [Hash] markers Map section markers to their note offset.
  # @raise [ArgumentError] if markers is not a Hash.
  def markers= markers
    raise ArgumentError, "markers is not a Hash" if !markers.is_a?(Hash)
  	@markers = markers
  end
  
  # Define program jumps (changes in execution flow). A jump maps a note offset
  # or marker where execution will jump to another note offset or marker.
  # 
  # @param [Hash] jumps Map note offsets or markers to where execution will jump to.
  # @raise [ArgumentError] if jumps is not a Hash.
  def jumps= jumps
    raise ArgumentError, "jumps is not a Hash" if !jumps.is_a?(Hash)
  	@jumps = jumps
  end

end

end

