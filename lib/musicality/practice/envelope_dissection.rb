require 'facets/equitable'

module Musicality

class EnvelopeFeature
  include Equitable(:type, :range)
  
  RISING = :envelopeSegmentRising
  FALLING = :envelopeSegmentFalling
  HOLDING = :envelopeSegmentHolding
  
  attr_reader :type
  attr_accessor :range
  
  def initialize type, range
    @type = type
    @range = range
  end
  
  def to_s
    case type
    when RISING
      return "R"
    when FALLING
      return "F"
    when HOLDING
      return "H"
    else
      return "?"
    end
  end
  
  def count
    @range.count
  end
  
  def count= count
    raise ArgumentError, "count #{count} is not at least 1" unless count >= 1
    @range = @range.first...(@range.first + count)
  end
  
  def rising?
    return @type == RISING
  end

  def falling?
    return @type == FALLING
  end
  
  def holding?
    return @type == HOLDING
  end
end

def rising range
  EnvelopeFeature.new(EnvelopeFeature::RISING, range)
end

def falling range
  EnvelopeFeature.new(EnvelopeFeature::FALLING, range)
end

def holding range
  EnvelopeFeature.new(EnvelopeFeature::HOLDING, range)
end

# Methods for breaking up an envelope into segments of
# rising, falling, and holding.
class EnvelopeDissection

  # break up an envelope into segments of rising, falling, and holding.
  # @return [Array] of EnvelopeFeature objects.
  def self.identify_features envelope, feature_threshold
    derivative = envelope.derivative.normalize
    features = []
    last_type_start = 0
    last_type = identify_feature_type derivative.data[0], feature_threshold
    
    for i in 1...derivative.data.count
      type = identify_feature_type derivative.data[i], feature_threshold
      
      if type != last_type
        features.push(EnvelopeFeature.new(last_type, last_type_start...i))
        last_type = type
        last_type_start = i
      end
    end
    
    features.push(EnvelopeFeature.new(last_type, last_type_start...derivative.data.count))
    return features
  end

  # Tries to eliminate segments with count shorter than given min count
  # by coalesing with neighboring segments.
  def self.coalesce_features features, min_feature_count
    
    coalesced = [ features[0] ]
    
    # look for following coalescing opportunities
    # 1. short holding segment (just tack count onto prev segment)
    # 2. short segment surrounded by two features of the same type (combine all three into one)
    
    i = 1
    while i < features.count do
      feature = features[i]
      
      incr = 1
      
      if feature.count < min_feature_count
        if feature.holding?
          coalesced.last.count += feature.count
        elsif (i < (features.count - 1) && (coalesced.last.type == features[i+1].type))
          coalesced.last.count += feature.count
          coalesced.last.count += features[i+1].count
          incr = 2
        else
          coalesced.push(feature)
        end
      else
        coalesced.push(feature)
      end
      i += incr
    end
    
    features = coalesced
    coalesced = []
    
    # look for two or more consecutive short features of same type to coalesce
    
    features.each do |feature|
      if coalesced.empty?
        coalesced.push feature
      elsif feature.type == coalesced.last.type
        coalesced.last.count += feature.count
      else
        coalesced.push feature
      end
    end
    
    return coalesced
  end
  
  def self.make_feature_string features
    str = ""
    features.each do |feature|
      str = str.concat feature.to_s
    end
    return str
  end

  private
  
  def self.identify_feature_type sample, feature_threshold
    if sample > feature_threshold
      type = EnvelopeFeature::RISING
    elsif sample < -feature_threshold
      type = EnvelopeFeature::FALLING
    else
      type = EnvelopeFeature::HOLDING
    end
    
    return type
  end
end
end
