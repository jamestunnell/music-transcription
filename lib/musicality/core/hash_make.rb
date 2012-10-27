require 'active_support'

module Musicality

  # Makes class instances following a hash-makeable (hash-args-only-during-
  # initialization) idiom.
  #
  # @author James Tunnell
  class HashMake
    # Test if a class can be made with hash-args. Class must define both 
    # REQUIRED_ARG_KEYS and OPTIONAL_ARG_KEYS constants to be hash-makeable.
    #
    # @param [Class] klass The class to be tested for hash-makeableness.
    def self.is_hash_makeable? klass
      klass.constants.include?(:REQUIRED_ARG_KEYS) && klass.constants.include?(:OPTIONAL_ARG_KEYS)
    end
    
    # Make a new class instance using the given hash-args.
    # @param [Class] klass The class to make a new instance of.
    # @param [Hash] hash The hash-args to use.
    # @raise [ArgumentError] if hash is not a Hash.
    # @raise [ArgumentError] if klass is not a Class.
    # @raise [ArgumentError] if klass is not hash-makeable.
    def self.make_from_hash klass, hash
      
      raise ArgumentError, "hash #{hash} is not a Hash" if !hash.is_a?(Hash)
      raise ArgumentError, "klass is not a Class" if !klass.is_a?(Class)
      raise ArgumentError, "klass is not hash-makeable" if !self.is_hash_makeable?(klass)
      
#      if !self.is_hash_makeable?(klass)
#        return klass.new hash
#      end
      
      args = {}
      
      #make required args
      klass::REQUIRED_ARG_KEYS.each do |key|
        raise ArgumentError, "hash #{hash} does not have required key #{key}" if !hash.has_key?(key)
        args[key] = make_a_val key, hash[key]
      end
      
      #if any optional keys are present
      klass::OPTIONAL_ARG_KEYS.each do |key|
        if hash.has_key?(key)
          args[key] = make_a_val key, hash[key]
        end
      end
      
      klass.new args
    end

    private
    
    def self.make_a_val key,val
      raise ArgumentError, "key #{key} is not a Symbol" if !key.is_a?(Symbol)
      
      if val.is_a?(Hash)
        clss = key_name_to_class key.to_s
        if self.is_hash_makeable?(clss)
          val = self.make_from_hash clss, val
        end
      elsif val.is_a?(Array)
        
        #because val is an array, we expect the key to be a plural (e.g. :notes)
        key_sing = ActiveSupport::Inflector.singularize key.to_s
        clss = nil
        begin
          clss = key_name_to_class key_sing
        rescue
        end
        
        if !clss.nil? && self.is_hash_makeable?(clss)
          ary = []
          val.each do |item|
            ary << self.make_from_hash(clss, item)
          end
          val = ary
        end
      end
      
      return val
    end
    
    def self.key_name_to_class key_name
      class_name = "Musicality::" + ActiveSupport::Inflector.camelize(key_name)
      ClassFinder.find_by_name class_name
    end
    
  end
end

