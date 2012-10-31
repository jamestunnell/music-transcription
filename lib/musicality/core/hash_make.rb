require 'active_support'

module Musicality

  # Makes class instances following a hash-makeable (hash-args-only-during-
  # initialization) idiom.
  # 
  # In order to be considered hash-makeable a class must define the following 
  # constants:
  #
  # REQUIRED_ARG_KEYS is an array contains the keys that must be present in
  # the hash that is passed to the constructor.
  #
  # OPTIONAL_ARG_KEYS is an array contains the keys that might no be present
  # in the hash that is passed to the constructor.
  #
  # OPTIONAL_ARG_DEFAULTS is a hash that maps the optional arg keys to their
  # default values (since the args may or may not be passed to constructor.
  #
  # Additionally, each instance must define instance variables that match the 
  # required arg keys.
  # 
  # @author James Tunnell
  class HashMake
    # Test if a class can be made with hash-args. Class must define the
    # REQUIRED_ARG_KEYS, OPTIONAL_ARG_KEYS, and OPTIONAL_ARG_DEFAULTS constants 
    # to be hash-makeable. Also, instance variables must be defined to match the
    # required arg keys. See HashMake class description for more details on what
    # constitutes a hash-makeable class.
    #
    # @param [Class] klass The class to be tested for hash-makeableness.
    def self.is_hash_makeable? klass, obj = nil
      is_hash_makeable = klass.constants.include?(:REQUIRED_ARG_KEYS) && 
                         klass.constants.include?(:OPTIONAL_ARG_KEYS) && 
                         klass.constants.include?(:OPTIONAL_ARG_DEFAULTS)

      if is_hash_makeable
        is_hash_makeable = klass::OPTIONAL_ARG_KEYS == klass::OPTIONAL_ARG_DEFAULTS.keys
      end
      
      if is_hash_makeable && !obj.nil?
        klass::REQUIRED_ARG_KEYS.each do |key|
          instance_var_name = ("@" + key.to_s).to_sym 
          if !obj.instance_variable_defined?(instance_var_name)
            is_hash_makeable = false
          end
        end
      end
      
      return is_hash_makeable
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

      args = {}
      
      #make required args
      klass::REQUIRED_ARG_KEYS.each do |key|
        raise ArgumentError, "hash #{hash} does not have required key #{key}" if !hash.has_key?(key)
        args[key] = make_val_from_hash_val key, hash[key]
      end
      
      #if any optional keys are present
      klass::OPTIONAL_ARG_KEYS.each do |key|
        if hash.has_key?(key)
          args[key] = make_val_from_hash_val key, hash[key]
        end
      end
      
      klass.new args
    end

    # Save an object to a representative hash, which could be use to hash-make 
    # an equivalent object.
    #
    # @param [Object] obj A hash-makeable object, to be made into a 
    #                     representative hash.
    def self.save_to_hash obj
      raise ArgumentError, "obj is not hash-makeable" if !self.is_hash_makeable?(obj.class, obj)
      
      hash = {}
      
      obj.class::REQUIRED_ARG_KEYS.each do |key|
        instance_var_name = ("@" + key.to_s).to_sym
        raise ArgumentError, "required arg key #{key} does not have an associated instance variable" if !obj.instance_variable_defined?(instance_var_name)
        val = obj.instance_variable_get(instance_var_name)
        hash[key] = self.make_hash_val_from_val val
      end

      obj.class::OPTIONAL_ARG_KEYS.each do |key|
        instance_var_name = ("@" + key.to_s).to_sym
        if obj.instance_variable_defined?(instance_var_name)
          default = obj.class::OPTIONAL_ARG_DEFAULTS[key]
          val = obj.instance_variable_get(instance_var_name)
          
          if val != default
            hash[key] = self.make_hash_val_from_val val
          end
        end
      end
      
      return hash
      
    end
    
    private
    
    def self.make_val_from_hash_val key, val
      raise ArgumentError, "key #{key} is not a Symbol" if !key.is_a?(Symbol)
      
      if val.is_a?(Hash)
        clss = key_name_to_class key.to_s
        if self.is_hash_makeable?(clss)
          val = self.make_from_hash clss, val
        end
      elsif val.is_a?(Array)
        
        #because val is an array, we expect the key to be a plural (e.g. :notes)
        key_sing = ActiveSupport::Inflector.singularize key.to_s
        clss = key_name_to_class key_sing
        
        if self.is_hash_makeable?(clss)
          ary = []
          val.each do |item|
            if item.class == clss
              ary << item
            else            
              ary << self.make_from_hash(clss, item)
            end
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
    
    def self.make_hash_val_from_val val
      
      hash_val = val
      
      if val.is_a?(Array)
        ary = val
        hash_val = []
        ary.each do |item|
          if self.is_hash_makeable? item.class
            hash_val << self.save_to_hash(item)
          else
            hash_val << item
          end
        end
      elsif self.is_hash_makeable? val.class
        hash_val = self.save_to_hash val
      end
      
      return hash_val
    end
    
  end
end

