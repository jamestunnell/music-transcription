module Musicality

# Combine functions that are each applicable for a non-overlapping range.
#
# @author James Tunnell
class PiecewiseFunction
  attr_reader :pieces
  
  def initialize
    @pieces = { }
  end
  
  def add_piece range, func
    
    raise ArgumentError, "range is not a Range" if !range.is_a? Range
    raise ArgumentError, "func is not a Proc" if !func.is_a? Proc
    
    both_overlaps = @pieces.select { |test_range, func| test_range.include?(range.begin) && test_range.include?(range.end) }
    if !both_overlaps.empty?
      raise StandardError, "only one overlap should ever occur" if both_overlaps.count > 1      
      
      orig_range_a = both_overlaps.keys.first.begin...range.begin
      orig_range_b = range.end...both_overlaps.keys.first.end
      orig_func = both_overlaps.values.first
      
      @pieces.delete both_overlaps.keys.first
      @pieces[orig_range_a] = orig_func
      @pieces[orig_range_b] = orig_func
    else
      min_overlaps = @pieces.select { |test_range, func| test_range.include?(range.begin) }

      if !min_overlaps.empty?
        raise StandardError, "only one overlap should ever occur" if min_overlaps.count > 1      
                
        orig_range = min_overlaps.keys.first.begin...range.begin
        orig_func = min_overlaps.values.first
          
        @pieces.delete min_overlaps.keys.first
        @pieces[orig_range] = orig_func
      end      

      max_overlaps = @pieces.select { |test_range, func| test_range.include? (range.end) }
      
      if !max_overlaps.empty?
        raise StandardError, "only one overlap should ever occur" if max_overlaps.count > 1      
        
        orig_range = range.end...max_overlaps.keys.first.end
        orig_func = max_overlaps.values.first
        
        @pieces.delete max_overlaps.keys.first
        @pieces[orig_range] = orig_func
      end
    end
    
    @pieces[range.begin...range.end] = func
  end
  
  def evaluate_at x
    y = nil
    
    @pieces.each do |range, func|
      if range.include? x
        y = func.call x
        break
      end
    end
    
    return y
  end
end

end
